codeunit 50320 "Purchase Management"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostLines', '', false, false)]
    local procedure OnBeforePostLines(PurchHeader: Record "Purchase Header")
    var
        Claims: Record Claims;
        PurchLine: Record "Purchase Line";
        GLAccount: Record "G/L Account";
    begin
        if not (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") then
            exit;

        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::"G/L Account");
        if PurchLine.FindFirst() then
            if GLAccount.Get(PurchLine."No.") then
                If GLAccount."Claiming Account" then begin
                    Clear(Claims);
                    Claims.SetRange("Source No.", PurchHeader."No.");
                    if not Claims.FindFirst() then
                        Error(NoReclamationErr)
                end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(PurchCrMemoHdrNo: Code[20]; var PurchaseHeader: Record "Purchase Header")
    var
        Claims: Record Claims;
        GLAccount: Record "G/L Account";
    begin
        if PurchCrMemoHdrNo = '' then
            Exit;

        Clear(Claims);
        Claims.SetRange("Source No.", PurchaseHeader."No.");
        if Claims.FindFirst() then begin
            Claims."Vendor Liquidation" := true;
            Claims.Modify();
        end;

        /* --REPLICAR HECHO EN VENTAS--
        if SalesCrMemoLine.Findset() then
            repeat
                Clear(Claims);
                Claims.SetRange("Source No.", SalesCrMemoLine."Applied warranty to Doc. No.");
                Claims.SetRange("Source Line No.", SalesCrMemoLine."Applied warranty to Line No.");
                if Claims.FindFirst() then
                    if (Claims."Customer No." = '') Or (Claims."Wheel Item No." = '') Or
                    (Claims."Plaque Code" = '') Or (Claims."Reclamation date" = 0D) Or
                    (Claims."M.E" = '') Or (Claims."Mm. Substract" = 0) then
                        Error(NoReclamationErr);
            until SalesCrMemoLine.Next() = 0;        
        */

    end;

    var
        NoReclamationErr: Label 'You must enter the information about the claim, Line button->Claims and fill in the fields indicated in red', comment = 'ESP="Debe introducir la informacion sobre la reclamación.Boton Linea->Reclamaciones y rellenar obligatoriamente los campos indicados en color rojo"';


}