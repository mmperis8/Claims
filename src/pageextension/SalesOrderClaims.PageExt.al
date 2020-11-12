pageextension 50321 "Sales Order Claims" extends "Sales Order"
{
    actions
    {
        addlast(processing)
        {
            action(CreateClaims)
            {
                Caption = 'Create claims', comment = 'ESP="Crear reclamación",PTG="Criar reclamação"';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = EntriesList;

                trigger OnAction()
                var
                    ClaimsManagement: Codeunit "Claims Management";
                begin
                    ClaimsManagement.CreateClaim(Rec);
                end;

            }
        }
    }
}