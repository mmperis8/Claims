codeunit 50321 "Sales Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesLineEvent(var Rec: Record "Sales Line")
    var
        Claims: Record Claims;
    begin
        if Rec."Document Type" <> Rec."Document Type"::"Credit Memo" then
            exit;
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit;

        Claims.SetRange("Source No.", Rec."Applied warranty to Doc. No.");
        Claims.SetRange("Source Line No.", Rec."Applied warranty to Line No.");
        if Claims.FindFirst() then
            Claims.Delete();

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateSalesLineNoEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        Claims: Record Claims;
        GLAccount: Record "G/L Account";
        SalesCrMemoHd: Record "Sales Header";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if Rec."Document Type" <> Rec."Document Type"::"Credit Memo" then
            exit;
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit;
        if GLAccount.Get(Rec."No.") then
            if not GLAccount."Claiming Account" then
                exit;
        if SalesCrMemoHd.Get(Rec."Document Type", Rec."Document No.") then;

        if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesCrMemoHd."Applied warranty to Doc. No.") then
            if SalesLine.Get(SalesHeader."Document Type", Rec."Applied warranty to Doc. No.", Rec."Applied warranty to Line No.") then begin
                Claims.Init();
                Claims."Source No." := SalesHeader."No.";
                Claims."Source Line No." := SalesLine."Line No.";
                Claims."Customer No." := SalesHeader."Sell-to Customer No.";
                Claims.Insert();
                Claims."Wheel Item No." := SalesLine."No.";
                Claims."Plaque Code" := SalesHeader."Plaque Code";
                Claims."Vehicle Kms." := SalesHeader."Vehicle Kms.";
                Claims.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesLines', '', false, false)]
    local procedure OnBeforePostSalesLines(var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
        SalesCrMemoLine: Record "Sales Line";
    begin
        if not (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") then
            exit;

        SalesCrMemoLine.SetRange("Document No.", SalesHeader."No.");
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::"G/L Account");
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

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(SalesCrMemoHdrNo: Code[20]; var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
    begin
        if SalesCrMemoHdrNo = '' then
            Exit;

        Clear(Claims);
        Claims.SetRange("Source No.", SalesHeader."No.");
        if Claims.FindFirst() then begin
            Claims."Customer Liquidation" := true;
            Claims.Modify();
        end;

    end;

    var
        NoReclamationErr: Label 'You must enter the information about the claim, Line button->Claims and fill in the fields indicated in red', comment = 'ESP="Debe introducir la informacion sobre la reclamación.Boton Linea->Reclamaciones y rellenar obligatoriamente los campos indicados en color rojo"';

}