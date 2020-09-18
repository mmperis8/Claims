page 50327 "Claims List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Claims;
    Caption = 'Claims List', comment = 'ESP="Lista de reclamaciones"';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Liquidation"; "Customer Liquidation")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Kms."; "Vehicle Kms.")
                {
                    ApplicationArea = All;
                }
                field("M.E"; "M.E")
                {
                    ApplicationArea = All;
                }
                field("Mm. Start"; "Mm. Start")
                {
                    ApplicationArea = All;
                }
                field("Mm. Substract"; "Mm. Substract")
                {
                    ApplicationArea = All;
                }
                field("Plaque Code"; "Plaque Code")
                {
                    ApplicationArea = All;
                }
                field("Reclamation date"; "Reclamation date")
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Liquidation"; "Vendor Liquidation")
                {
                    ApplicationArea = All;
                }
                field("Vendor Observations"; "Vendor Observations")
                {
                    ApplicationArea = All;
                }
                field("Wheel Item No."; "Wheel Item No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }
}