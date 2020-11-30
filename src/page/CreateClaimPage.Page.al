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

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'O.R. No.', comment = 'ESP="Nº O.R.",PTG="Nº O.R"';
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Plaque Code"; Rec."Plaque Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Account; Account)
                {
                    ApplicationArea = All;
                    Caption = 'Account', comment = 'ESP="Cuenta",PTG="Conta"';
                    ShowMandatory = true;
                    TableRelation = "G/L Account" where("Claiming Account" = const(true));

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
                    ShowMandatory = true;
                }
                field(WheelItemNo; WheelItemNo)
                {
                    Caption = 'Wheel Item No.', comment = 'ESP="Nº producto rueda",PTG="N.º do produto roda"';
                    ApplicationArea = All;
                    TableRelation = Item;
                    ShowMandatory = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        SalesLine: Record "Sales Line";
                        FamilyCode: Code[20];
                        ItemList: Page "Item List";
                    begin
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        if SalesLine.FindFirst() then
                            if Item.Get(SalesLine."No.") then
                                FamilyCode := Item.Family;
                        Clear(Item);
                        Item.FilterGroup(2);
                        Item.SetRange(Family, FamilyCode);
                        Item.FilterGroup(0);
                        Clear(ItemList);
                        ItemList.SetTableView(Item);
                        ItemList.LookupMode(true);
                        ItemList.Editable(false);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            ItemList.GetRecord(Item);
                            WheelItemNo := Item."No.";
                        end;
                    end;
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
                var
                    EmptyFieldErr: Label 'Mandatory fields must have a value', comment = 'ESP="Los campos obligatorios deben tener un valor",PTG="Os campos obrigatórios devem ter um valor"';
                begin
                    if (Account = '') Or (AmountToCrMemo = 0) Or (WheelItemNo = '') then
                        Error(EmptyFieldErr);
                    ClaimsManagement.CreateSalesCrMemo(Rec, AmountToCrMemo, Account, WheelItemNo, M_E, Vehicle_KM, Mm_Start, Mm_Substract);
                    CurrPage.Close();
                end;
            }
            action(ClaimList)
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Claims List', comment = 'ESP="Lista de reclamaciones",PTG="Lista de reclamações"';
                RunObject = page "Claims List";
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