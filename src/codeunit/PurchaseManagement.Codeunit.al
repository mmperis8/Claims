codeunit 50320 "Purchase Management"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostLines', '', false, false)]
    local procedure OnBeforePostLines(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        if not (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") then
            exit;

        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet() then
            repeat
                if PurchLine."Claim No." = 0 then
                    Error(NoClaimErr);
            until PurchLine.Next() = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(PurchCrMemoHdrNo: Code[20]; var PurchaseHeader: Record "Purchase Header")
    var
        Claims: Record Claims;
        PurchaseLine: Record "Purchase Line";
    begin

        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::"Credit Memo" then
            exit;

        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
        if PurchaseLine.FindSet() then
            repeat
                Clear(Claims);
                Claims.SetRange("No.", PurchaseLine."Claim No.");
                if Claims.FindFirst() then begin
                    Claims."Vendor Liquidation" := true;
                    Claims."Vendor Cr Memo No." := PurchaseHeader."No.";
                    Claims."Vendor Cr Memo Amount" := PurchaseLine.Amount;
                    Claims."Vendor Account" := PurchaseLine."No.";
                    Claims.Modify();
                end;
            until PurchaseLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure OnAfterValidatePurchLineDescriptionEvent(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        Claims: Record Claims;
    begin
        if (Rec."Document Type" <> Rec."Document Type"::"Credit Memo") or (Rec.Type <> Rec.Type::"G/L Account") then
            exit;

        Claims.SetRange("No.", Rec."Claim No.");
        if Claims.FindFirst() then begin
            Claims."Vendor Observations" := Rec.Description;
            Claims.Modify();
        end;
    end;

    var
        NoReclamationErr: Label 'You must enter the information about the claim, Line button->Claims and fill in the fields indicated in red', comment = 'ESP="Debe introducir la informacion sobre la reclamación.Boton Linea->Reclamaciones y rellenar obligatoriamente los campos indicados en color rojo"';
        NoClaimErr: Label 'You must specifie a claim no. on line %1', comment = 'ESP="Debe indicar el número de reclamación en la línea %1"';

}