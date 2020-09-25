page 50328 "Create Claim Page"
{
    PageType = Card;
    PromotedActionCategories = 'Process';
    Caption = 'Create Claim', comment = 'ESP="Creación de reclamaciones",PTG="Criação de reivindicações"';
    SourceTable = "Sales Header";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;

                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Caption = 'O.R. No.', comment = 'ESP="Nº O.R.",PTG="Nº O.R"';
                    Editable = false;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Plaque Code"; "Plaque Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Account; Account)
                {
                    ApplicationArea = All;
                    Caption = 'Account', comment = 'ESP="Cuenta",PTG="Conta"';
                }
                field(AmountToCrMemo; AmountToCrMemo)
                {
                    ApplicationArea = All;
                    Caption = 'Amount', comment = 'ESP="Importe",PTG="Montante"';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CancelWarranty)
            {
                ApplicationArea = All;
                Image = CancelledEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Cancel claim',
                    comment = 'ESP="Anular reclamación",PTG="Cancelar cobranças"';

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
            action(CreateClaim)
            {
                ApplicationArea = All;
                Image = ApplyTemplate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Create Claim',
                    comment = 'ESP="Crear reclamación",PTG="Criar reclamação"';

                trigger OnAction()
                begin
                    ClaimsManagement.CreateSalesCrMemo(Rec, AmountToCrMemo, Account);
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        ClaimsManagement: Codeunit "Claims Management";
        AmountToCrMemo: Decimal;
        Account: Code[20];

}