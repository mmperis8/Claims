codeunit 50321 "Sales Management"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesLines', '', false, false)]
    local procedure OnBeforePostSalesLines(var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
        SalesCrMemoLine: Record "Sales Line";
        GLAccount: Record "G/L Account";
    begin
        if not (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") then
            exit;

        SalesCrMemoLine.SetRange("Document No.", SalesHeader."No.");
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::"G/L Account");
        if SalesCrMemoLine.FindFirst() then
            if GLAccount.GET(SalesCrMemoLine."No.") then
                if GLAccount."Claiming Account" then begin
                    Clear(Claims);
                    Claims.SetRange("Source No.", SalesHeader."No.");
                    if not Claims.FindFirst() then
                        Error(NoReclamationErr)
                end;
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