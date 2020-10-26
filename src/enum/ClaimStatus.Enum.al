enum 50322 "Claim Status"
{
    Extensible = true;

    value(0; "")
    {
    }
    value(1; "Vendor Pending")
    {
        Caption = 'Vendor Pending', comment = 'ESP="Pte. Proveedor",PTG="Pte. Fornecedor"';
    }
    value(2; "Documentation Pending")
    {
        Caption = 'Documentation Pending', comment = 'ESP="Pte. Documentación",PTG="Pte. Documentação"';
    }
    value(3; "Logistics Pending")
    {
        Caption = 'Logistics Pending', comment = 'ESP="Pte. Logistica",PTG="Pte. Logistica"';
    }
    value(4; "Cr. Memo Receipt Pending")
    {
        Caption = 'Cr. Memo Receipt Pending', comment = 'ESP="Pte. Recibir Abono",PTG="Pte. Receber Crédito"';
    }
    value(5; "Warranty Pending")
    {
        Caption = 'Warranty Pending', comment = 'ESP="Pte. Garantías",PTG="Pte. Garantiaas"';
    }
}