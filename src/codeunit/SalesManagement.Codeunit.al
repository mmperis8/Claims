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

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line")
    begin
        SalesLine."Applied warranty to Doc. No." := TempSalesLine."Applied warranty to Doc. No.";
        SalesLine."Applied warranty to Line No." := TempSalesLine."Applied warranty to Line No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateSalesLineNoEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        GLAccount: Record "G/L Account";
        ClaimingAccErr: Label 'The specified account is meant to be used on the claims process', comment = 'ESP="La cuenta especificada está pensada para usarse en el circuito de reclamaciones",PTG="A conta especificada destina-se a ser utilizada no circuito de reclamações"';
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if GLAccount.Get(Rec."No.") then
            if GLAccount."Claiming Account" then
                Error(ClaimingAccErr);
    end;
    /*
        [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
        local procedure OnAfterValidateCrMemoLineNoEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
        var
            Claims: Record Claims;
            GLAccount: Record "G/L Account";
            SalesHeader: Record "Sales Header";
            SalesLine: Record "Sales Line";
        begin
            Clear(Claims);
            Claims.SetRange("Source No.", Rec."Applied warranty to Doc. No.");
            Claims.SetRange("Source Line No.", Rec."Applied warranty to Line No.");
            if Claims.FindFirst() then
                Claims.Delete();

            if Rec."Document Type" <> Rec."Document Type"::"Credit Memo" then
                exit;
            if Rec.Type <> Rec.Type::"G/L Account" then
                exit;
            if GLAccount.Get(Rec."No.") then
                if not GLAccount."Claiming Account" then
                    exit;

            Clear(Claims);
            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Applied warranty to Doc. No.") then
                if SalesLine.Get(SalesHeader."Document Type", Rec."Applied warranty to Doc. No.", Rec."Applied warranty to Line No.") then begin
                    Claims.Init();
                    Claims."Source No." := SalesHeader."No.";
                    Claims."Source Line No." := SalesLine."Line No.";
                    Claims."Customer No." := SalesHeader."Sell-to Customer No.";
                    Claims.Insert(true);
                    Claims."Wheel Item No." := SalesLine."No.";
                    Claims."Plaque Code" := SalesHeader."Plaque Code";
                    Claims."Vehicle Kms." := SalesHeader."Vehicle Kms.";
                    Claims.Modify();
                end;
        end;
    */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesLines', '', false, false)]
    local procedure OnBeforePostSalesLines(var SalesHeader: Record "Sales Header")
    var
        Claims: Record Claims;
        SalesCrMemoLine: Record "Sales Line";
    begin

        SalesCrMemoLine.SetRange("Applied warranty to Doc. No.", SalesHeader."No.");
        if SalesCrMemoLine.Findset() then
            repeat
                Clear(Claims);
                Claims.SetRange("Source No.", SalesCrMemoLine."Applied warranty to Doc. No.");
                Claims.SetRange("Source Line No.", SalesCrMemoLine."Applied warranty to Line No.");
                if Claims.FindFirst() then
                    if (Claims."Customer No." = '') Or (Claims."Wheel Item No." = '') Or
                    (Claims."Reclamation date" = 0D) Or
                    (Claims."M.E" = '') Or (Claims."Mm. Substract" = 0) then
                        Error(NoReclamationErr);
            until SalesCrMemoLine.Next() = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', true, true)]
    local procedure OnAfterFinalizePostingOnBeforeCommit(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesCrMemoHeader: Record "Sales Header";
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) And (SalesHeader.Invoice) then begin
            SalesCrMemoHeader.SetRange("Applied warranty to Doc. No.", SalesHeader."No.");
            if SalesCrMemoHeader.FindFirst() then begin
                SalesCrMemoHeader."Corrected Invoice No." := SalesInvoiceHeader."No.";
                SalesCrMemoHeader.Modify();
                Codeunit.RUN(Codeunit::"Sales-Post", SalesCrMemoHeader);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
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