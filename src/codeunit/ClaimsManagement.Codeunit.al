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
        SalesCrMemoHeader.Operator := Rec.Operator;
        SalesCrMemoHeader."Repair Responsible" := Rec."Repair Responsible";
        SalesCrMemoHeader."Plaque Code" := Rec."Plaque Code";
        SalesCrMemoHeader."Vehicle Kms." := Rec."Vehicle Kms.";
        SalesCrMemoHeader.Modify();

        CreateSalesCrMemoLine(Rec, SalesCrMemoHeader, AmountToCrMemo, Account);
        CreateClaimRecord(Rec, Account);
    end;

    local procedure CreateSalesCrMemoLine(Rec: Record "Sales Header"; SalesCrMemoHeader: Record "Sales Header"; AmountToCrMemo: Decimal; Account: Code[20])
    var
        SalesCrMemoLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
    begin

        LineNo := 10000;
        SalesLine.SetRange("Document No.", Rec."No.");
        if not SalesLine.FindSet() then
            Error('');

        repeat
            SalesCrMemoLine.Init();
            SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
            SalesCrMemoLine."Document Type" := SalesCrMemoHeader."Document Type";
            SalesCrMemoLine."Line No." := LineNo;
            SalesCrMemoLine.Type := SalesCrMemoLine.Type::"G/L Account";
            SalesCrMemoLine.VALIDATE("Line Discount %", 0);
            if SalesLine.Count = 1 then begin
                SalesCrMemoLine.Validate("No.", Account);
                SalesCrMemoLine.Validate(Quantity, 1);
                SalesCrMemoLine.Validate("Unit Price", AmountToCrMemo);
            end;
            SalesCrMemoLine."Applied warranty to Doc. No." := SalesLine."Document No.";
            SalesCrMemoLine."Applied warranty to Line No." := SalesLine."Line No.";
            SalesCrMemoLine.Insert(true);
            LineNo += 10000;
        until SalesLine.Next() = 0;

    end;

    local procedure CreateClaimRecord(Rec: Record "Sales Header"; Account: Code[20])
    var
        Claims: Record Claims;
        SalesLine: Record "Sales Line";
        GLAccount: Record "G/L Account";
    begin

        SalesLine.SetRange("Document No.", Rec."No.");
        if not SalesLine.FindSet() then
            Error('');

        if Account = '' then
            exit;

        if GLAccount.GET(Account) then
            if not GLAccount."Claiming Account" then
                exit;

        Claims.SetRange("Source No.", Rec."No.");
        Claims.SetRange("Source Line No.", SalesLine."Line No.");
        if Claims.FindFirst() then
            exit;

        if SalesLine.Count = 1 then begin
            Claims.Init();
            Claims."Source No." := Rec."No.";
            Claims."Source Line No." := SalesLine."Line No.";
            Claims."Customer No." := Rec."Sell-to Customer No.";
            Claims."Reclamation date" := WorkDate();
            Claims."Wheel Item No." := SalesLine."No.";
            Claims."Plaque Code" := Rec."Plaque Code";
            Claims."Vehicle Kms." := Rec."Vehicle Kms.";
            Claims.Insert(true);
        end;

    end;

}