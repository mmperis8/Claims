codeunit 50322 "Claims Management"
{
    procedure CreateClaim(var SalesHeader: Record "Sales Header")
    begin

        SalesHeader.TESTFIELD("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.TESTFIELD("Sell-to Customer No.");
        SalesHeader.TESTFIELD("Plaque code");

        SalesHeader.FilterGroup(6);
        SalesHeader.setrange("No.", SalesHeader."No.");
        SalesHeader.FilterGroup(0);
        commit();
        Page.RunModal(PAGE::"Create Claim Page", SalesHeader);

    end;

    procedure CreateSalesCrMemo(Rec: Record "Sales Header"; AmountToCrMemo: Decimal; Account: Code[20])
    var
        SalesCrMemoHeader: Record "Sales Header";
    begin
        SalesCrMemoHeader.Init();
        SalesCrMemoHeader.SetHideValidationDialog(true);

        SalesCrMemoHeader."Document Type" := SalesCrMemoHeader."Document Type"::"Credit Memo";
        SalesCrMemoHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
        SalesCrMemoHeader.Insert(true);

        SalesCrMemoHeader."Applied warranty to Doc. No." := Rec."No.";
        SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Open;
        SalesCrMemoHeader.Modify();

        CreateSalesCrMemoLine(Rec, SalesCrMemoHeader, AmountToCrMemo, Account);
        CreateClaimRecord(Rec, SalesCrMemoHeader, Account);
    end;

    local procedure CreateSalesCrMemoLine(Rec: Record "Sales Header"; SalesCrMemoHeader: Record "Sales Header"; AmountToCrMemo: Decimal; Account: Code[20])
    var
        SalesCrMemoLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
    begin

        SalesLine.SetRange("Document No.", Rec."No.");
        if not SalesLine.FindSet() then
            Error('');

        repeat
            SalesCrMemoLine.Init();
            SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
            SalesCrMemoLine."Document Type" := SalesCrMemoHeader."Document Type";
            SalesCrMemoLine.Insert(true);

            SalesCrMemoLine.Type := SalesCrMemoLine.Type::"G/L Account";
            if SalesLine.Count = 1 then
                SalesCrMemoLine."No." := Account;
            SalesCrMemoLine.Validate("Line Amount", AmountToCrMemo);
            SalesCrMemoLine.Validate(Quantity, 1);
            SalesCrMemoLine.Modify();
        until SalesLine.Next() = 0;

    end;

    local procedure CreateClaimRecord(Rec: Record "Sales Header"; SalesCrMemoHeader: Record "Sales Header"; Account: Code[20])
    var
        Claims: Record Claims;
        SalesLine: Record "Sales Line";
        GLAccount: Record "G/L Account";
    begin

        SalesLine.SetRange("Document No.", Rec."No.");
        if not SalesLine.FindSet() then
            Error('');

        if GLAccount.GET(Account) then
            if not GLAccount."Claiming Account" then
                exit;

        repeat
            Claims.Init();
            Claims."Source No." := SalesCrMemoHeader."No.";
            Claims."Customer No." := Rec."Sell-to Customer No.";
            Claims.Insert();
            Claims."Wheel Item No." := SalesLine."No.";
            Claims."Plaque Code" := Rec."Plaque Code";
            Claims."Vehicle Kms." := Rec."Vehicle Kms.";
            Claims.Modify();
        until SalesLine.Next() = 0;

    end;

}