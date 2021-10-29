pageextension 50323 "Sales Credit Memo Claims" extends "Sales Credit Memo"
{
    actions
    {
        addlast(navigation)
        {
            action(ClaimList)
            {
                Caption = 'Claim List', Comment = 'ESP="Lista de reclamaciones",PTG=""';
                Image = List;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category10;
                RunObject = page "Claims List";
            }
        }
    }
}