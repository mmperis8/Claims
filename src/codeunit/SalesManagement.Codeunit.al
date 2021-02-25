codeunit 50321 "Sales Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAferValidateNoSalesLine(var Rec: Record "Sales Line")
    var
        Claims: Record Claims;
        ClaimsErr: Label 'There is a claim related to this order. It is not possible to report accounts in the lines of a sales order with claims', comment = 'ESP="Existe una reclamación relacionada con este pedido. No es posible informar cuentas en las línias de un pedido de venta con reclamaciones",PTG="Há uma reclamação relacionada com esta encomenda. Não é possível reportar contas nas linhas de uma ordem de venda com queixas"';
    begin
        Claims.SetRange("Source No.", Rec."Document No.");
        if not Claims.IsEmpty() then
            Error(ClaimsErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line")
    begin
        SalesLine."Applied warranty to Doc. No." := TempSalesLine."Applied warranty to Doc. No.";
        SalesLine."Applied warranty to Line No." := TempSalesLine."Applied warranty to Line No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNoSalesCrMemSubform(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        Claims: Record Claims;
        GLAccount: Record "G/L Account";
        ClaimingAccMsg: Label 'The specified account is going to create a claim, do you wish to continue?', comment = 'ESP="La cuenta especificada creará una reclamación, desea continuar?",PTG="A conta especificada irá criar uma reclamação, gostaria de continuar?"';
        ClaimingAccErr: Label 'The specified account is meant to be used on the claims process', comment = 'ESP="La cuenta especificada está pensada para usarse en el circuito de reclamaciones",PTG="A conta especificada destina-se a ser utilizada no circuito de reclamações"';
    begin
        if Rec."Document Type" <> Rec."Document Type"::"Credit Memo" then
            exit;

        if Rec.Type = Rec.Type::"G/L Account" then
            if GLAccount.Get(Rec."No.") then
                if GLAccount."Claiming Account" then
                    if not Rec.GetHideValidationDialog() then
                        if not Confirm(ClaimingAccMsg) then
                            Error(ClaimingAccErr)
                        else begin
                            SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                            Claims.Init();
                            Claims."Source No." := Rec."Document No.";
                            if Claims."Source Line No." = 0 then
                                Claims."Source Line No." := 10000
                            else
                                Claims."Source Line No." := Rec."Line No.";
                            Claims."Customer No." := Rec."Sell-to Customer No.";
                            Claims."Reclamation date" := WorkDate();
                            Claims."Plaque Code" := SalesHeader."Plaque Code";
                            Claims.Insert(true);
                            Page.Run(Page::"Claims List", Claims);
                        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNoSalesOrderSub(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        GLAccount: Record "G/L Account";
        ClaimingAccErr: Label 'The specified account is meant to be used on the claims process', comment = 'ESP="La cuenta especificada está pensada para usarse en el circuito de reclamaciones",PTG="A conta especificada destina-se a ser utilizada no circuito de reclamações"';
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.Type = Rec.Type::"G/L Account" then
            if GLAccount.Get(Rec."No.") then
                if GLAccount."Claiming Account" then
                    Error(ClaimingAccErr);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesLines', '', false, false)]
    local procedure OnBeforePostSalesLines(var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
        SalesCrMemoLine: Record "Sales Line";
    begin
        SalesCrMemoLine.SetCurrentKey("Applied warranty to Doc. No.");
        SalesCrMemoLine.SetRange("Applied warranty to Doc. No.", SalesHeader."No.");
        if SalesCrMemoLine.Findset() then
            repeat
                Clear(Claims);
                Claims.SetRange("Source No.", SalesCrMemoLine."Applied warranty to Doc. No.");
                Claims.SetRange("Source Line No.", SalesCrMemoLine."Applied warranty to Line No.");
                if Claims.FindFirst() then
                    if (Claims."Customer No." = '') Or (Claims."Wheel Item No." = '') Or
                    (Claims."Reclamation date" = 0D) Or
                    (Claims."Source No." = '') then
                        Error(NoReclamationErr);
            until SalesCrMemoLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesInvHdEvent(var Rec: Record "Sales Invoice Header")
    var
        SalesCrMemoHeader: Record "Sales Header";
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Order No.") then begin
            SalesCrMemoHeader.SetCurrentKey("Applied warranty to Doc. No.");
            SalesCrMemoHeader.SetRange("Applied warranty to Doc. No.", Rec."Order No.");
            if SalesCrMemoHeader.FindFirst() then begin
                if SalesCrMemoHeader."Payment Method Code" = '' then
                    SalesCrMemoHeader."Payment Method Code" := Rec."Payment Method Code";
                if SalesCrMemoHeader."External Document No." = '' then begin
                    SalesCrMemoHeader."Corrected Invoice No." := Rec."No.";
                    SalesCrMemoHeader."External Document No." := Rec."No.";
                end;
                SalesCrMemoHeader.Modify();
                Codeunit.RUN(Codeunit::"Sales-Post", SalesCrMemoHeader);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
    begin
        Clear(Claims);
        Claims.SetRange("Source No.", SalesHeader."No.");
        if Claims.FindSet(true) then
            repeat
                Claims."Customer Liquidation" := true;
                Claims.Modify();
            until Claims.Next() = 0;
    end;

    var
        NoReclamationErr: Label 'You must enter the information about the claim', comment = 'ESP="Debe introducir la informacion sobre la reclamación",PTG="Deve introduzir as informações sobre a reclamação"';

}