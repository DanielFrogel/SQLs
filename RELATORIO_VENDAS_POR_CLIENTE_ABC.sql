SELECT np.empresa,
    np.numero,
    np.serie,
    n.id_tipo_nota,
    n.emissao,
    n.vendedor,
    v.nome AS vendedor_nome,
   (CASE WHEN N.TIPO = 'S' THEN (SELECT C.CNPJ FROM CLIENTES C WHERE C.CODIGO = N.CLIENTE) ELSE
             (SELECT F.CNPJ FROM FORNECEDORES F WHERE F.CODIGO = N.CLIENTE) END) cliente_cnpj,
   (CASE WHEN N.TIPO = 'S' THEN (SELECT C.NOME FROM CLIENTES C WHERE C.CODIGO = N.CLIENTE) ELSE
             (SELECT F.NOME FROM FORNECEDORES F WHERE F.CODIGO = N.CLIENTE) END) cliente_nome,
    np.produto,
    prod.descricao,
    prod.grupo,
    gr.nome AS grupo_nome,
    prod.codigo_fabricante,
    forn.nome AS fabricante,
    np.quantidade,
    np.unitario,
    np.total,
    n.tipo,
    (SELECT proc.out_soma_total FROM procedure_curva_abc_cliente(:EMP_INI,:EMP_FIM,:SERIE_INI,:SERIE_FIM,:N_INI,:N_FIM,:DINI,:DFIM,:GR_INI,:GR_FIM,
            np.cliente,:V,:FAB,n.tipo) proc) AS soma_total      

FROM notaprodutos np
    inner JOIN notas n on (n.numero = np.numero AND n.serie = np.serie AND n.empresa = np.empresa)
    inner JOIN produtos prod on (prod.codigo = np.produto)
    inner JOIN grupos gr on (prod.grupo = gr.codigo)
    LEFT JOIN fornecedores forn on (prod.codigo_fabricante = forn.codigo)
    LEFT JOIN clientes c on (c.codigo = np.cliente)
    LEFT JOIN vendedores v on (v.codigo = n.vendedor)
WHERE
    n.emissao BETWEEN :DINI AND :DFIM AND
    np.empresa BETWEEN :EMP_INI AND :EMP_FIM AND
    np.serie BETWEEN :SERIE_INI AND :SERIE_FIM AND
    np.numero BETWEEN :N_INI AND :N_FIM AND
    prod.grupo BETWEEN :GR_INI AND :GR_FIM AND
    coalesce(n.vendedor,'') like :V || '%' AND
    coalesce(prod.codigo_fabricante,'') like :FAB || '%' AND
    N.ID_TIPO_NOTA IN (1,3,6) AND
    n.cancelada <> 'S'
 
ORDER BY &ORDEM

-- PARAMETER:'EMP_INI';TYPE:'TEXT';DESCRIPTION:'Empresa Inicial';SIZE:003;DEFAULT:'EMP';ZEROS:'NAO'
-- PARAMETER:'EMP_FIM';TYPE:'TEXT';DESCRIPTION:'Empresa Final';SIZE:003;DEFAULT:'EMP';ZEROS:'NAO'
-- PARAMETER:'SERIE_INI';TYPE:'TEXT';DESCRIPTION:'Série Inicial';SIZE:003;DEFAULT:'';ZEROS:'NAO'
-- PARAMETER:'SERIE_FIM';TYPE:'TEXT';DESCRIPTION:'Série Fim';SIZE:003;DEFAULT:'ZZZ';ZEROS:'NAO'
-- PARAMETER:'N_INI';TYPE:'TEXT';DESCRIPTION:'Número Inicial';SIZE:009;DEFAULT:'000001';ZEROS:'NAO'
-- PARAMETER:'N_FIM';TYPE:'TEXT';DESCRIPTION:'Número Final';SIZE:009;DEFAULT:'999999';ZEROS:'NAO'
-- PARAMETER:'DINI';TYPE:'DATE';DESCRIPTION:'Emissão';DEFAULT:'HOJE'
-- PARAMETER:'DFIM';TYPE:'DATE';DESCRIPTION:'até';DEFAULT:'HOJE'
-- PARAMETER:'GR_INI';TYPE:'TEXT';DESCRIPTION:'Grupo Inicial';SIZE:020;BUTTON:'GRUPOS';DEFAULT:'001';ZEROS:'NAO'
-- PARAMETER:'GR_FIM';TYPE:'TEXT';DESCRIPTION:'Grupo Final';SIZE:020;;BUTTON:'GRUPOS';DEFAULT:'999';ZEROS:'NAO'
-- PARAMETER:'V';TYPE:'TEXT';DESCRIPTION:'Vendedor';SIZE:003;BUTTON:'VENDEDORES';ZEROS:'NAO'
-- PARAMETER:'FAB';TYPE:'TEXT';DESCRIPTION:'Fabricante';SIZE:014;BUTTON:'FORNECEDORES';ZEROS:'NAO'

-- ORDER:'soma_total desc, np.numero';DESCRIPTION:'Total de Venda'
-- ORDER:'cliente_nome, np.numero';DESCRIPTION:'Nome do Cliente'
-- ORDER:'cliente_cnpj, np.numero';DESCRIPTION:'CNPJ do Cliente'create or alter procedure PROCEDURE_CURVA_ABC_CLIENTE (
    IN_EMP_INI varchar(3),
    IN_EMP_FIM varchar(3),
    IN_SINI varchar(20),
    IN_SFIM varchar(20),
    IN_NINI varchar(20),
    IN_NFIM varchar(20),
    IN_DINI date,
    IN_DFIM date,
    IN_GINI varchar(20),
    IN_GFIM varchar(20),
    IN_CLI varchar(18),
    IN_VEND varchar(3),
    IN_FAB varchar(14),
    IN_TIPO varchar(1))
returns (
    OUT_SOMA_TOTAL numeric(15,2))
as
declare variable TOTAL_DEVOLUCAO numeric(15,6);
declare variable SQL varchar(2000);
declare variable TOTAL_VENDA numeric(15,6);
declare variable CNPJ_CLIENTE varchar(18);
BEGIN
    total_devolucao = 0;
    total_venda = 0;

        if (:IN_TIPO = 'S') then
        begin
           select cnpj from clientes where codigo = :IN_CLI
           into : cnpj_cliente;
        end
        else
        begin
           select cnpj from fornecedores where codigo = :IN_CLI
           into : cnpj_cliente;
        end

   SQL = 'select SUM(np1.total) total from notaprodutos np1
            inner join notas n1 on (n1.numero = np1.numero and n1.serie = np1.serie and n1.empresa = np1.empresa and n1.cliente = np1.cliente)
            left join clientes c1 on (c1.codigo = n1.cliente and n1.tipo = ''S'')
            left join fornecedores f1 on (f1.codigo = np1.cliente and n1.tipo = ''E'')
            inner join produtos prod1 on (prod1.codigo = np1.produto)
            inner join grupos gr1 on (prod1.grupo = gr1.codigo)
            left join fornecedores forn1 on (prod1.codigo_fabricante = forn1.codigo)
            left join vendedores v1 on (v1.codigo = n1.vendedor)
            where
                np1.empresa between ''' || :IN_EMP_INI || '''AND '''  || :IN_EMP_FIM || '''AND
                n1.emissao between ''' || :IN_DINI || '''AND '''  || :IN_DFIM || '''AND
                np1.serie between ''' ||  :IN_SINI || '''AND '''  || :IN_SFIM || '''AND
                np1.numero between  ''' || :IN_NINI || '''AND '''  || :IN_NFIM || '''AND
                prod1.grupo between  ''' || :IN_GINI || '''AND '''  || :IN_GFIM || '''AND
    
                c1.cnpj = ''' || :cnpj_cliente || '''AND

                coalesce(n1.vendedor,'''') like ''' || :IN_VEND || '%'' AND
                coalesce(prod1.codigo_fabricante,'''') like ''' || :IN_FAB || '%'' AND
                N1.ID_TIPO_NOTA IN (1,3,6) and
                n1.cancelada <> ''S'' and n1.tipo=''S''';

    execute statement SQL INTO :total_venda;

   SQL = 'select SUM(np1.total) total from notaprodutos np1
            inner join notas n1 on (n1.numero = np1.numero and n1.serie = np1.serie and n1.empresa = np1.empresa and n1.cliente = np1.cliente)
            left join clientes c1 on (c1.codigo = n1.cliente and n1.tipo = ''S'')
            left join fornecedores f1 on (f1.codigo = np1.cliente and n1.tipo = ''E'')
            inner join produtos prod1 on (prod1.codigo = np1.produto)
            inner join grupos gr1 on (prod1.grupo = gr1.codigo)
            left join fornecedores forn1 on (prod1.codigo_fabricante = forn1.codigo)
            left join vendedores v1 on (v1.codigo = n1.vendedor)
            where
                np1.empresa between ''' || :IN_EMP_INI || '''AND '''  || :IN_EMP_FIM || '''AND
                n1.emissao between ''' || :IN_DINI || '''AND '''  || :IN_DFIM || '''AND
                np1.serie between ''' ||  :IN_SINI || '''AND '''  || :IN_SFIM || '''AND
                np1.numero between  ''' || :IN_NINI || '''AND '''  || :IN_NFIM || '''AND
                prod1.grupo between  ''' || :IN_GINI || '''AND '''  || :IN_GFIM || '''AND
    
                f1.cnpj = ''' || :cnpj_cliente || '''AND

                coalesce(n1.vendedor,'''') like ''' || :IN_VEND || '%'' AND
                coalesce(prod1.codigo_fabricante,'''') like ''' || :IN_FAB || '%'' AND
                N1.ID_TIPO_NOTA IN (1,3,6) and
                n1.cancelada <> ''S'' and n1.tipo=''E''';

    execute statement SQL INTO :total_devolucao;

    if (total_devolucao is null) then
       total_devolucao = 0;

    if (total_venda is null) then
       total_venda = 0;

    out_soma_total = total_venda + (total_devolucao*-1);

        SUSPEND;

END<?xml version="1.0" encoding="utf-8" standalone="no"?>
<TfrxReport Version="6.9.14" DotMatrixReport="False" IniFile="c:\wle_sistemas\Fast Reports" PreviewOptions.Buttons="4095" PreviewOptions.Zoom="1" PrintOptions.Printer="Padr?o" PrintOptions.PrintOnSheet="0" ReportOptions.CreateDate="41901,4571771412" ReportOptions.Description.Text="" ReportOptions.LastChange="45384,6212612269" ScriptLanguage="PascalScript" ScriptText.Text="var&#13;&#10;  var_total_cliente, var_total : Real;                    &#13;&#10;  &#13;&#10;procedure PageFooter1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;&#13;&#10;   MmFooterWLE.text := 'Â© WLE SoluÃ§Ãµes em Software - '+FormatDateTime('YYYY', DATE)+' | (41) 4042-9777';&#13;&#10;end;&#13;&#10;&#13;&#10;procedure MasterData1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;  if &#60;SQL Mestre.&#34;ID_TIPO_NOTA&#34;&#62; &#60;&#62; '3' then              &#13;&#10;    var_total_cliente := var_total_cliente + StrtoFloat(&#60;SQL Mestre.&#34;TOTAL&#34;&#62;)&#13;&#10;  else&#13;&#10;  begin&#13;&#10;    var_total_cliente := var_total_cliente - StrtoFloat(&#60;SQL Mestre.&#34;TOTAL&#34;&#62;);              &#13;&#10;    SQLMestreTOTAL.Text := '- ' + SQLMestreTOTAL.Text;  &#13;&#10;  end;                  &#13;&#10;end;                    &#13;&#10;&#13;&#10;procedure GroupFooter1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;  //total_cliente.Text := FormatSpace('###,###,##0.00', Arredonda(var_total_cliente,2),15);&#13;&#10;  var_total := var_total + var_total_cliente;&#13;&#10;  var_total_cliente := 0;                                              &#13;&#10;end;&#13;&#10;&#13;&#10;procedure Footer1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;  total.Text := FormatSpace('#,###,###,##0.00', Arredonda(var_total,2),15);                            &#13;&#10;end;&#13;&#10;&#13;&#10;procedure MasterData1OnAfterPrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;  SQLMestreTOTAL.Text := '[SQL Mestre.&#34;TOTAL&#34;]'       &#13;&#10;end;&#13;&#10;&#13;&#10;begin&#13;&#10;&#13;&#10;end.">
  <Datasets>
    <item DataSet="DataSetMaster" DataSetName="SQL Mestre"/>
  </Datasets>
  <TfrxDataPage Name="Data" HGuides.Text="" VGuides.Text="" Height="1000" Left="0" Top="0" Width="1000"/>
  <TfrxReportPage Name="Page1" HGuides.Text="" VGuides.Text="" Orientation="poLandscape" PaperWidth="297" PaperHeight="210" PaperSize="9" LeftMargin="10" RightMargin="10" TopMargin="10" BottomMargin="10" ColumnWidth="0" ColumnPositions.Text="" Frame.Typ="0" MirrorMode="0">
    <TfrxMasterData Name="MasterData1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="13,22834646" Left="0" Top="222,99227" Width="1046,92981" OnAfterPrint="MasterData1OnAfterPrint" OnBeforePrint="MasterData1OnBeforePrint" ColumnWidth="0" ColumnGap="0" DataSet="DataSetMaster" DataSetName="SQL Mestre" RowCount="0">
      <TfrxMemoView Name="SQLMestreEMPRESA" IndexTag="1" AllowVectorExport="True" Left="3,77953" Top="0" Width="30,23622047" Height="13,22834646" DataField="EMPRESA" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;EMPRESA&#34;]"/>
      <TfrxMemoView Name="SQLMestreDESCRICAO" IndexTag="1" AllowVectorExport="True" Left="374,173228346457" Top="0" Width="215,43307087" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;PRODUTO&#34;] - [SQL Mestre.&#34;DESCRICAO&#34;]">
        <Formats>
          <item/>
          <item/>
        </Formats>
      </TfrxMemoView>
      <TfrxMemoView Name="SQLMestreNUMERO1" IndexTag="1" AllowVectorExport="True" Left="34,01577" Top="0" Width="49,13385827" Height="13,22834646" DataField="NUMERO" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;NUMERO&#34;]"/>
      <TfrxMemoView Name="SQLMestreSERIE" IndexTag="1" AllowVectorExport="True" Left="83,1496063" Top="0" Width="30,2362204724409" Height="13,22834646" DataField="SERIE" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;SERIE&#34;]"/>
      <TfrxMemoView Name="SQLMestreID_TIPO_NOTA" IndexTag="1" AllowVectorExport="True" Left="113,38582677" Top="0" Width="26,45669291" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;ID_TIPO_NOTA&#34;]">
        <Formats>
          <item/>
          <item/>
        </Formats>
      </TfrxMemoView>
      <TfrxMemoView Name="SQLMestreEMISSAO" IndexTag="1" AllowVectorExport="True" Left="139,84251969" Top="0" Width="68,03148386" Height="13,22834646" DataField="EMISSAO" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;EMISSAO&#34;]"/>
      <TfrxMemoView Name="SQLMestreVENDEDOR" IndexTag="1" AllowVectorExport="True" Left="207,874015748031" Top="0" Width="166,2992126" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;VENDEDOR&#34;] - [SQL Mestre.&#34;VENDEDOR_NOME&#34;]"/>
      <TfrxMemoView Name="SQLMestreGRUPO" IndexTag="1" AllowVectorExport="True" Left="589,60668" Top="0" Width="94,48820118" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" WordWrap="False" Text="[SQL Mestre.&#34;GRUPO&#34;] - [SQL Mestre.&#34;GRUPO_NOME&#34;]"/>
      <TfrxMemoView Name="SQLMestreCODIGO_FABRICANTE" IndexTag="1" AllowVectorExport="True" Left="684,09493" Top="0" Width="173,85826772" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;CODIGO_FABRICANTE&#34;] - [SQL Mestre.&#34;FABRICANTE&#34;]"/>
      <TfrxMemoView Name="SQLMestreQUANTIDADE" IndexTag="1" AllowVectorExport="True" Left="857,95331" Top="0" Width="64,251968503937" Height="13,22834646" DataField="QUANTIDADE" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;QUANTIDADE&#34;]"/>
      <TfrxMemoView Name="SQLMestreUNITARIO" IndexTag="1" AllowVectorExport="True" Left="922,20472441" Top="0" Width="45,35433071" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;UNITARIO&#34;]"/>
      <TfrxMemoView Name="SQLMestreTOTAL" IndexTag="1" AllowVectorExport="True" Left="967,55905512" Top="0" Width="75,59055118" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;TOTAL&#34;]"/>
    </TfrxMasterData>
    <TfrxPageFooter Name="PageFooter1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="22,67718" Left="0" Top="385,51206" Width="1046,92981" OnBeforePrint="PageFooter1OnBeforePrint">
      <TfrxMemoView Name="TotalPages" AllowVectorExport="True" Left="942,10297" Top="3,77954465" Width="102,04731" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Page#] / [TotalPages#]"/>
      <TfrxMemoView Name="MmFooterWLE" AllowVectorExport="True" Left="3,77953" Top="12,77953" Width="600,94527" Height="11,33859" Font.Charset="1" Font.Color="0" Font.Height="-5" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text=""/>
    </TfrxPageFooter>
    <TfrxPageHeader Name="PageHeader1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="105,82684" Left="0" Top="18,89765" Width="1046,92981">
      <TfrxMemoView Name="Memo2" AllowVectorExport="True" Left="778,58318" Top="22,67718" Width="94,48825" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="Data:"/>
      <TfrxMemoView Name="Date" AllowVectorExport="True" Left="880,63049" Top="22,67718" Width="86,92919" Height="18,89765" Font.Charset="1" Font.Color="-16777208" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[Date]"/>
      <TfrxMemoView Name="Time" AllowVectorExport="True" Left="975,11874" Top="22,67718" Width="68,03154" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Time]"/>
      <TfrxLineView Name="Line2" AllowVectorExport="True" Left="3,77953" Top="45,35436" Width="1039,37075" Height="0" Color="0" Frame.Typ="4"/>
      <TfrxMemoView Name="RetornaEmpresa" AllowVectorExport="True" Left="7,55906" Top="22,67718" Width="434,64595" Height="18,89765" Frame.Typ="0" Text="RelatÃ³rio de Vendas por Cliente"/>
      <TfrxMemoView Name="RetornaEmpresa1" AllowVectorExport="True" Left="7,55906" Top="0" Width="438,42548" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="[RetornaEmpresa('DESCRICAO')]"/>
      <TfrxMemoView Name="RetornaEmpresa2" AllowVectorExport="True" Left="778,58318" Top="0" Width="264,5671" Height="18,89765" Frame.Typ="0" HAlign="haRight" Text="[RetornaEmpresa('NUMEROINSCRICAO')]"/>
      <TfrxMemoView Name="Memo1" AllowVectorExport="True" Left="3,77953" Top="64,25201" Width="264,5671" Height="18,89765" Frame.Typ="0" Text="PerÃ­odo: [RetornaParametroString('DINI')] atÃ© [RetornaParametroString('DFIM')]"/>
      <TfrxMemoView Name="Memo3" AllowVectorExport="True" Left="3,77953" Top="90,70872" Width="30,23624" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Emp"/>
      <TfrxMemoView Name="SQLMestreNUMERO" IndexTag="1" AllowVectorExport="True" Left="34,01577" Top="90,70872" Width="49,13389" Height="15,11812" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="NÃºmero"/>
      <TfrxMemoView Name="Memo5" AllowVectorExport="True" Left="83,14966" Top="90,70872" Width="30,23624" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="SÃ©rie"/>
      <TfrxMemoView Name="Memo6" AllowVectorExport="True" Left="113,3859" Top="90,70872" Width="26,45671" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Tipo"/>
      <TfrxMemoView Name="Memo7" AllowVectorExport="True" Left="139,84261" Top="90,70872" Width="68,03154" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="EmissÃ£o"/>
      <TfrxMemoView Name="Memo9" AllowVectorExport="True" Left="207,87415" Top="90,70872" Width="166,29932" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Vendedor"/>
      <TfrxMemoView Name="Memo10" AllowVectorExport="True" Left="374,17347" Top="90,70872" Width="215,43321" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Produto"/>
      <TfrxMemoView Name="Memo11" AllowVectorExport="True" Left="589,60668" Top="90,70872" Width="94,48825" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Grupo"/>
      <TfrxMemoView Name="Memo12" AllowVectorExport="True" Left="684,09493" Top="90,70872" Width="173,85838" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Fabricante"/>
      <TfrxMemoView Name="Memo13" AllowVectorExport="True" Left="857,95331" Top="90,70872" Width="64,25201" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Quantidade"/>
      <TfrxMemoView Name="Memo14" AllowVectorExport="True" Left="922,20532" Top="90,70872" Width="45,35436" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="UnitÃ¡rio"/>
      <TfrxMemoView Name="Memo15" AllowVectorExport="True" Left="967,55968" Top="90,70872" Width="75,5906" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="Total"/>
    </TfrxPageHeader>
    <TfrxGroupHeader Name="GroupHeader1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="15,11812" Left="0" Top="185,19697" Width="1046,92981" Condition="SQL Mestre.&#34;CLIENTE_CNPJ&#34;">
      <TfrxMemoView Name="SQLMestreCLIENTE_NOME" IndexTag="1" AllowVectorExport="True" Left="52,91342" Top="0" Width="472,44125" Height="15,11812" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="8" ParentFont="False" Text="[SQL Mestre.&#34;CLIENTE_CNPJ&#34;] - [SQL Mestre.&#34;CLIENTE_NOME&#34;]">
        <Formats>
          <item/>
          <item/>
        </Formats>
      </TfrxMemoView>
      <TfrxMemoView Name="Memo4" AllowVectorExport="True" Left="3,77953" Top="0" Width="49,13389" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="1" Frame.Typ="8" ParentFont="False" Text="Cliente:"/>
    </TfrxGroupHeader>
    <TfrxGroupFooter Name="GroupFooter1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="18,89765" Left="0" Top="260,78757" Width="1046,92981" OnBeforePrint="GroupFooter1OnBeforePrint">
      <TfrxMemoView Name="Memo16" AllowVectorExport="True" Left="778,58318" Top="0" Width="136,06308" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="Total do Cliente:"/>
      <TfrxMemoView Name="SQLMestreSOMA_TOTAL" IndexTag="1" AllowVectorExport="True" Left="914,64626" Top="0" Width="128,50402" Height="18,89765" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;SOMA_TOTAL&#34;]"/>
    </TfrxGroupFooter>
    <TfrxFooter Name="Footer1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="22,67718" Left="0" Top="302,3624" Width="1046,92981" OnBeforePrint="Footer1OnBeforePrint">
      <TfrxMemoView Name="Memo17" AllowVectorExport="True" Left="778,58318" Top="3,77953" Width="136,06308" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="Total:"/>
      <TfrxSysMemoView Name="total" AllowVectorExport="True" Left="914,64626" Top="3,77953" Width="128,50402" Height="18,89765" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text=""/>
    </TfrxFooter>
  </TfrxReportPage>
</TfrxReport>
