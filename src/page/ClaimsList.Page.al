page 50327 "Claims List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Claims;
    Caption = 'Claims List', comment = 'ESP="Lista de reclamaciones",PTG="Lista de reclamações"';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
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
}