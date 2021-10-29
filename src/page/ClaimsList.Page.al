page 50327 "Claims List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Claims;
    Caption = 'Claims List', Comment = 'ESP="Lista de reclamaciones",PTG="Lista de reclamações"';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Wheel Item No."; Rec."Wheel Item No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Plaque Code"; Rec."Plaque Code")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Tire Id."; "Tire Id.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Reclamation date"; Rec."Reclamation date")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("M.E"; Rec."M.E")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Vehicle Kms."; Rec."Vehicle Kms.")
                {
                    ApplicationArea = All;
                }
                field("Mm. Start"; Rec."Mm. Start")
                {
                    ApplicationArea = All;
                }
                field("Mm. Substract"; Rec."Mm. Substract")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Observations"; Rec."Vendor Observations")
                {
                    ApplicationArea = All;
                }
                field("Vendor Cr Memo No."; Rec."Vendor Cr Memo No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Cr Memo Amount"; Rec."Vendor Cr Memo Amount")
                {
                    ApplicationArea = All;
                }
                field("Vendor Account"; Rec."Vendor Account")
                {
                    ApplicationArea = All;
                }
                field("Customer Liquidation"; Rec."Customer Liquidation")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Liquidation"; Rec."Vendor Liquidation")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(ClaimSheet)
            {
                Caption = 'Print Claim Sheet', Comment = 'ESP="Imprimir hoja reclamación",PTG="Imprimir folha reclamação"';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Claims: Record Claims;
                begin
                    Claims := Rec;
                    Claims.SetRecFilter();
                    Report.RunModal(Report::"Claim Sheet", true, false, Claims);
                end;
            }
            action(BlankClaimSheet)
            {
                Caption = 'Print Blank Claim Sheet', Comment = 'ESP="Imprimir hoja reclamación en blanco",PTG="Imprimir folha reclamação em branco"';
                Image = PrintCover;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Claims: Record Claims;
                    ClaimSheet: Report "Claim Sheet";
                begin
                    Claims := Rec;
                    Claims.SetRecFilter();
                    Clear(ClaimSheet);
                    ClaimSheet.SetTableView(Claims);
                    ClaimSheet.SetEmptySheet();
                    ClaimSheet.RunModal();
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Claims: Record Claims;
        ClaimErrNo: Code[20];
        NoReclamationErr: Label 'Warning !\You must enter the information about the claim %1', Comment = 'ESP="¡ Aviso !\Debe introducir toda la informacion sobre la reclamación %1",PTG="Atenção !\Deve introduzir as informações sobre a reclamação %1"';
    begin
        ClaimErrNo := '';
        Claims.Reset();
        if Claims.FindSet(false) then
            repeat
                if (Claims."Customer No." = '') or (Claims."Wheel Item No." = '') or (Claims."Reclamation date" = 0D) or
                   (Claims."Source No." = '') then
                    ClaimErrNo := Claims."No.";
            until ((ClaimErrNo <> '') or (Claims.Next() = 0));
        if ClaimErrNo <> '' then
            Message(NoReclamationErr, ClaimErrNo);
    end;
}