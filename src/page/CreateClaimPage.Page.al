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

                    trigger OnValidate()
                    var
                        GLAccount: Record "G/L Account";
                        NoExistingAccErr: Label 'The specifies account does not exist', comment = 'ESP="La cuenta especificada no existe",PTG="A conta especificada não existe"';
                        NotClaimingAccErr: Label 'The specified account cannot be used as it is not a claims account', comment = 'ESP="La cuenta especificada no puede ser usada al no ser una cuenta de reclamaciones",PTG="A conta especificada não pode ser utilizada porque não é uma conta de créditos"';
                    begin
                        if not GLAccount.Get(Account) then
                            Error(NoExistingAccErr);
                        if not GLAccount."Claiming Account" then
                            Error(NotClaimingAccErr);
                    end;
                }
                field(AmountToCrMemo; AmountToCrMemo)
                {
                    ApplicationArea = All;
                    Caption = 'Amount', comment = 'ESP="Importe",PTG="Montante"';
                }
                field(WheelItemNo; WheelItemNo)
                {
                    Caption = 'Wheel Item No.', comment = 'ESP="Nº producto rueda",PTG="N.º do produto roda"';
                    ApplicationArea = All;
                }
                field(M_E; M_E)
                {
                    Caption = 'M.E', comment = 'ESP="M.E",PTG="M.E"';
                    ApplicationArea = All;
                }
                field(Vehicle_KM; Vehicle_KM)
                {
                    Caption = 'Vehicle Kms.', comment = 'ESP="Km. Uso",PTG="Km. Utilização"';
                    ApplicationArea = All;
                }
                field(Mm_Start; Mm_Start)
                {
                    Caption = 'Mm. Start', comment = 'ESP="Mm. Inicio",PTG="Mm. Início"';
                    ApplicationArea = All;
                }
                field(Mm_Substract; Mm_Substract)
                {
                    Caption = 'Mm. Substract', comment = 'ESP="Mm. Resto",PTG="Mm. Descanso"';
                    ApplicationArea = All;
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

                    ClaimsManagement.CreateSalesCrMemo(Rec, AmountToCrMemo, Account, WheelItemNo, M_E, Vehicle_KM, Mm_Start, Mm_Substract);
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        ClaimsManagement: Codeunit "Claims Management";
        AmountToCrMemo: Decimal;
        Account: Code[20];
        WheelItemNo: Code[20];
        M_E: Code[50];
        Vehicle_KM: Integer;
        Mm_Start: Decimal;
        Mm_Substract: Decimal;

}