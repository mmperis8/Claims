table 50321 "Claims Setup"
{
    Caption = 'Claims Setup', comment = 'ESP="Conf. reclamaciones"';
    DataClassification = OrganizationIdentifiableInformation;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', comment = 'ESP="Clave Primaria"';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(2; "Claim Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Claim No.', comment = 'ESP="Nº Reclamación",PTG="Nº Reivindicação"';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}