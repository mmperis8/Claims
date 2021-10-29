codeunit 50322 "Claims Management"
{
    procedure CreateClaim(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Order.AsInteger());
        SalesHeader.TestField("Sell-to Customer No.");
        SalesHeader.FilterGroup(6);
        SalesHeader.Setrange("No.", SalesHeader."No.");
        SalesHeader.FilterGroup(0);
        Commit();
        Page.RunModal(PAGE::"Create Claim Page", SalesHeader);
    end;

    procedure CreateSalesCrMemo(Rec: Record "Sales Header"; AmountToCrMemo: Decimal; Account: Code[20]; WheelItemNo: Code[20]; M_E: Code[50]; Vehicle_KM: Integer; Mm_Start: Decimal; Mm_Substract: Decimal; TireId: Text[30])
    var
        SalesCrMemoHeader: Record "Sales Header";
        SalesCrMemoLine: Record "Sales Line";
        ClaimSetup: Record "Claims Setup";
    begin
        Clear(SalesCrMemoHeader);
        SalesCrMemoHeader.SetCurrentKey("Applied warranty to Doc. No.");
        SalesCrMemoHeader.SetRange("Applied warranty to Doc. No.", Rec."No.");
        if SalesCrMemoHeader.IsEmpty() then begin
            ClaimSetup.Get();
            ClaimSetup.TestField("Default Return Reason");
            Clear(SalesCrMemoHeader);
            SalesCrMemoHeader.Init();
            SalesCrMemoHeader.SetHideValidationDialog(true);
            SalesCrMemoHeader."Document Type" := SalesCrMemoHeader."Document Type"::"Credit Memo";
            SalesCrMemoHeader."Applied warranty to Doc. No." := Rec."No.";
            SalesCrMemoHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
            SalesCrMemoHeader.Insert(true);
            SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Open;
            SalesCrMemoHeader.Operator := Rec.Operator;
            SalesCrMemoHeader."Repair Responsible" := Rec."Repair Responsible";
            SalesCrMemoHeader."Plaque Code" := Rec."Plaque Code";
            SalesCrMemoHeader."Vehicle Kms." := Rec."Vehicle Kms.";
            SalesCrMemoHeader."Return Reason Code" := ClaimSetup."Default Return Reason";
            SalesCrMemoHeader.Modify();
        end;
        CreateSalesCrMemoLine(Rec, SalesCrMemoHeader, AmountToCrMemo, Account, SalesCrMemoLine);
        CreateClaimRecord(Rec, Account, WheelItemNo, M_E, Vehicle_KM, Mm_Start, Mm_Substract, TireId, SalesCrMemoLine);
    end;

    local procedure CreateSalesCrMemoLine(Rec: Record "Sales Header"; SalesCrMemoHeader: Record "Sales Header"; AmountToCrMemo: Decimal; Account: Code[20]; var SalesCrMemoLine: Record "Sales Line")
    var
        SalesLine: Record "Sales Line";
        ClaimSetup: Record "Claims Setup";
        LineNo: Integer;
        NoLineErr: Label 'There is no line in the original sales order to settle this claim', Comment = 'ESP="No se encuentra línia en el pedido de venta origen para liquidar esta reclamación",PTG="Não há linha na ordem de venda original para resolver esta reclamação"';
    begin
        ClaimSetup.Get();
        ClaimSetup.TestField("Default Return Reason");
        LineNo := 10000;
        Clear(SalesCrMemoLine);
        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        SalesCrMemoLine.SetRange("Document Type", SalesCrMemoHeader."Document Type");
        if SalesCrMemoLine.FindLast() then
            LineNo := SalesCrMemoLine."Line No." + 10000;

        if not SalesLine.Get(Rec."Document Type", Rec."No.", LineNo) then
            Error(NoLineErr);

        Clear(SalesCrMemoLine);
        SalesCrMemoLine.SetHideValidationDialog(true);
        SalesCrMemoLine.Init();
        SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
        SalesCrMemoLine."Document Type" := SalesCrMemoHeader."Document Type";
        SalesCrMemoLine."Line No." := LineNo;
        SalesCrMemoLine.Insert(true);
        SalesCrMemoLine.Type := SalesCrMemoLine.Type::"G/L Account";
        SalesCrMemoLine.VALIDATE("Line Discount %", 0);
        if Account <> '' then
            SalesCrMemoLine.Validate("No.", Account);
        SalesCrMemoLine.Validate(Quantity, 1);
        if AmountToCrMemo <> 0 then
            SalesCrMemoLine.Validate("Unit Price", AmountToCrMemo);

        SalesCrMemoLine."Applied warranty to Doc. No." := SalesLine."Document No.";
        SalesCrMemoLine."Applied warranty to Line No." := SalesLine."Line No.";
        SalesCrMemoLine."Return Reason Code" := ClaimSetup."Default Return Reason";
        SalesCrMemoLine.Modify();

    end;

    local procedure CreateClaimRecord(Rec: Record "Sales Header"; Account: Code[20]; WheelItemNo: Code[20]; M_E: Code[50]; Vehicle_KM: Integer; Mm_Start: Decimal; Mm_Substract: Decimal; TireId: Text[30]; SalesCrMemoLine: Record "Sales Line")
    var
        Claims: Record Claims;
        GLAccount: Record "G/L Account";
    begin
        if Account = '' then
            exit;

        if GLAccount.Get(Account) then
            if not GLAccount."Claiming Account" then
                exit;

        Claims.Init();
        Claims."Source No." := SalesCrMemoLine."Applied warranty to Doc. No.";
        Claims."Source Line No." := SalesCrMemoLine."Applied warranty to Line No.";
        Claims."Customer No." := Rec."Sell-to Customer No.";
        Claims."Reclamation date" := WorkDate();
        Claims."Wheel Item No." := WheelItemNo;
        Claims."Plaque Code" := Rec."Plaque Code";
        Claims."Vehicle Kms." := Vehicle_KM;
        Claims."M.E" := M_E;
        Claims."Mm. Start" := Mm_Start;
        Claims."Mm. Substract" := Mm_Substract;
        Claims."Tire Id." := TireId;
        Claims.Insert(true);
        Page.Run(Page::"Claims List", Claims);
    end;

}