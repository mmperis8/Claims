codeunit 50321 "Sales Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAferValidateNoSalesLine(var Rec: Record "Sales Line")
    var
        Claims: Record Claims;
        ClaimsErr: Label 'There is a claim related to this order. It is not possible to report accounts in the lines of a sales order with claims', Comment = 'ESP="Existe una reclamación relacionada con este pedido. No es posible informar cuentas en las línias de un pedido de venta con reclamaciones",PTG="Há uma reclamação relacionada com esta encomenda. Não é possível reportar contas nas linhas de uma ordem de venda com queixas"';
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
        ClaimingAccMsg: Label 'The specified account is going to create a claim, do you wish to continue?', Comment = 'ESP="La cuenta especificada creará una reclamación, desea continuar?",PTG="A conta especificada irá criar uma reclamação, gostaria de continuar?"';
        ClaimingAccErr: Label 'The specified account is meant to be used on the claims process', Comment = 'ESP="La cuenta especificada está pensada para usarse en el circuito de reclamaciones",PTG="A conta especificada destina-se a ser utilizada no circuito de reclamações"';
    begin
        if Rec."Document Type" <> Rec."Document Type"::"Credit Memo" then
            exit;
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit;
        if not GLAccount.Get(Rec."No.") then
            exit;
        if not GLAccount."Claiming Account" then
            exit;
        if not Rec.GetHideValidationDialog() then begin
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
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNoSalesOrderSub(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        GLAccount: Record "G/L Account";
        ClaimingAccErr: Label 'The specified account is meant to be used on the claims process', Comment = 'ESP="La cuenta especificada está pensada para usarse en el circuito de reclamaciones",PTG="A conta especificada destina-se a ser utilizada no circuito de reclamações"';
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit;
        if not GLAccount.Get(Rec."No.") then
            exit;
        if GLAccount."Claiming Account" then
            Error(ClaimingAccErr);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesLines', '', false, false)]
    local procedure OnBeforePostSalesLines(var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
        SalesCrMemoLine: Record "Sales Line";
        NoReclamationErr: Label 'You must enter the information about the claim', Comment = 'ESP="Debe introducir la informacion sobre la reclamación",PTG="Deve introduzir as informações sobre a reclamação"';
    begin
        SalesCrMemoLine.SetCurrentKey("Applied warranty to Doc. No.");
        SalesCrMemoLine.SetRange("Applied warranty to Doc. No.", SalesHeader."No.");
        if SalesCrMemoLine.Findset(false) then
            repeat
                Claims.Reset();
                Claims.SetRange("Source No.", SalesCrMemoLine."Applied warranty to Doc. No.");
                Claims.SetRange("Source Line No.", SalesCrMemoLine."Applied warranty to Line No.");
                if Claims.FindFirst() then begin
                    if (Claims."Customer No." = '') or (Claims."Wheel Item No." = '') or (Claims."Reclamation date" = 0D) or
                        (Claims."Source No." = '') then
                        Error(NoReclamationErr);
                end;
            until SalesCrMemoLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure ClaimsOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; RetRcpHdrNo: Code[20]; InvtPickPutaway: Boolean; CommitIsSuppressed: Boolean)
    var
        SalesCrMemoHeader: Record "Sales Header";
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        if SalesInvHdrNo = '' then
            exit;
        SalesInvHdr.Get(SalesInvHdrNo);
        SalesCrMemoHeader.SetCurrentKey("Applied warranty to Doc. No.");
        SalesCrMemoHeader.SetRange("Applied warranty to Doc. No.", SalesInvHdr."Order No.");
        if SalesCrMemoHeader.FindFirst() then begin
            if SalesCrMemoHeader."Payment Method Code" = '' then
                SalesCrMemoHeader."Payment Method Code" := SalesInvHdr."Payment Method Code";
            if SalesCrMemoHeader."External Document No." = '' then begin
                SalesCrMemoHeader."Corrected Invoice No." := SalesInvHdr."No.";
                SalesCrMemoHeader."External Document No." := SalesInvHdr."No.";
            end;
            SalesCrMemoHeader.Modify();
            Codeunit.Run(Codeunit::"Sales-Post", SalesCrMemoHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
    begin
        Claims.Reset();
        Claims.SetRange("Source No.", SalesHeader."No.");
        if Claims.FindSet(true) then
            repeat
                Claims."Customer Liquidation" := true;
                Claims.Modify();
            until Claims.Next() = 0;
    end;
}