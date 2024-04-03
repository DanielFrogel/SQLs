SELECT
    N.NUMERO,
    N.SERIE,
    CLI.NOME AS NOME_CLIENTE,
    CLI.CNPJ,
    N.EMISSAO,
    N.PLACA,
    N.VENDEDOR,
    COALESCE(V.NOME, 'Sem Vendedor') AS NOME_VENDEDOR,
    PROD.GRUPO,
    GR.NOME,
    SUM(NP.TOTAL) AS TOTAL_GRUPO

FROM NOTAS N
    
    INNER JOIN CLIENTES CLI ON (N.CLIENTE = CLI.CODIGO)
    INNER JOIN NOTAPRODUTOS NP ON (NP.NUMERO = N.NUMERO) AND (NP.SERIE = N.SERIE)
    INNER JOIN PRODUTOS PROD ON (NP.PRODUTO = PROD.CODIGO)
    INNER JOIN GRUPOS GR ON (GR.CODIGO = PROD.GRUPO)
    LEFT JOIN VENDEDORES V ON (V.CODIGO = N.VENDEDOR)

WHERE
   N.EMISSAO BETWEEN :DATA_INI AND :DATA_FIM
   AND N.CLIENTE LIKE :CLI || '%'
   AND N.PLACA LIKE :PLACA || '%'
   AND N.VENDEDOR LIKE :VENDEDOR || '%'
   AND PROD.GRUPO BETWEEN :GRUPO_INI AND :GRUPO_FIM
   AND NOT COALESCE(N.GERADO_NFE,'X') IN ('D','C','I')
   AND COALESCE(N.CANCELADA,'N') <> 'S'
   AND N.TIPO = 'S'
   AND (0 IN (0&ID_TIPO_NOTA) OR N.ID_TIPO_NOTA IN (&ID_TIPO_NOTA))

GROUP BY 1,2,3,4,5,6,7,8,9,10

ORDER BY &ORDEM


-- PARAMETER:'DATA_INI';TYPE:'DATE';DESCRIPTION:'Emissão Inicial';DEFAULT:'HOJE'
-- PARAMETER:'DATA_FIM';TYPE:'DATE';DESCRIPTION:'Emissão Final';DEFAULT:'HOJE'
-- PARAMETER:'GRUPO_INI';TYPE:'TEXT';DESCRIPTION:'Grupo Inicial';SIZE:020;ZEROS:'NAO;BUTTON:'GRUPOS';DEFAULT:'001'
-- PARAMETER:'GRUPO_FIM';TYPE:'TEXT';DESCRIPTION:'Grupo Final';SIZE:020;ZEROS:'NAO;BUTTON:'GRUPOS';DEFAULT:'999'
-- PARAMETER:'PLACA';TYPE:'TEXT';DESCRIPTION:'Placa';SIZE:008;ZEROS:'NAO
-- PARAMETER:'CLI';TYPE:'TEXT';DESCRIPTION:'Cliente';SIZE:014;BUTTON:'CLIENTES';ZEROS:'NAO'
-- PARAMETER:'VENDEDOR';TYPE:'TEXT';DESCRIPTION:'Vendedor';SIZE:003;BUTTON:'VENDEDORES';ZEROS:'NAO'
-- PARAMETER:'ID_TIPO_NOTA';TYPE:'TEXT';DESCRIPTION:'Tipo da nota fiscal (instruções nos comentários)';SIZE:020;BUTTON:'TIPOSNOTAFISCAL';DEFAULT:'0'

-- ORDER:'GR.NOME,N.NUMERO';DESCRIPTION:'Ordenar por Número de Nota'
-- ORDER:'GR.NOME,N.VENDEDOR,N.NUMERO';DESCRIPTION:'Ordenar por Vendedor'

<?xml version="1.0" encoding="utf-8" standalone="no"?>
<TfrxReport Version="6.9.14" DotMatrixReport="False" IniFile="c:\wle_sistemas\Fast Reports" PreviewOptions.Buttons="4095" PreviewOptions.Zoom="1" PrintOptions.Printer="Padr?o" PrintOptions.PrintOnSheet="0" ReportOptions.CreateDate="41901,4571771412" ReportOptions.Description.Text="" ReportOptions.LastChange="45345,3917175" ScriptLanguage="PascalScript" ScriptText.Text="procedure PageFooter1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;&#13;&#10;   MmFooterWLE.text := 'Â© WLE Tecnologia em AutomaÃ§Ã£o - '+FormatDateTime('YYYY', DATE)+' | MATRIZ - UniÃ£o da VitÃ³ria/PR: (41)4042-9777 | Unidade Ponta Grossa/PR: (42)3225-5839 | Unidade Mafra/SC: (47) 3645-1480 ';&#13;&#10;end;&#13;&#10;&#13;&#10;procedure MasterData1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;&#13;&#10;end;&#13;&#10;&#13;&#10;procedure GroupHeader1OnAfterPrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;&#13;&#10;end;&#13;&#10;&#13;&#10;procedure GroupFooter2OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;&#13;&#10;end;&#13;&#10;&#13;&#10;begin&#13;&#10;&#13;&#10;end.">
  <Datasets>
    <item DataSet="DataSetMaster" DataSetName="SQL Mestre"/>
  </Datasets>
  <TfrxDataPage Name="Data" HGuides.Text="" VGuides.Text="" Height="1000" Left="0" Top="0" Width="1000"/>
  <TfrxReportPage Name="Page1" HGuides.Text="" VGuides.Text="" PaperWidth="210" PaperHeight="297" PaperSize="9" LeftMargin="10" RightMargin="10" TopMargin="10" BottomMargin="10" ColumnWidth="0" ColumnPositions.Text="" Frame.Typ="0" MirrorMode="0">
    <TfrxMasterData Name="MasterData1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="11,33859" Left="0" Top="211,65368" Width="718,1107" OnBeforePrint="MasterData1OnBeforePrint" ColumnWidth="0" ColumnGap="0" DataSet="DataSetMaster" DataSetName="SQL Mestre" RowCount="0">
      <TfrxMemoView Name="SQLMestreNUMERO" IndexTag="1" AllowVectorExport="True" Left="234,81889764" Top="0" Width="98,26771654" Height="11,33858268" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;NUMERO&#34;] / [SQL Mestre.&#34;SERIE&#34;]"/>
      <TfrxMemoView Name="SQLMestreEMISSAO" IndexTag="1" AllowVectorExport="True" Left="119,54330709" Top="0" Width="113,3859" Height="11,33858268" DataField="EMISSAO" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;EMISSAO&#34;]"/>
      <TfrxMemoView Name="SQLMestreVALOR_TOTAL_NOTA" IndexTag="1" AllowVectorExport="True" Left="633,07086614" Top="0" Width="81,25984252" Height="11,33859" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;TOTAL_GRUPO&#34;]"/>
      <TfrxMemoView Name="Memo11" IndexTag="1" AllowVectorExport="True" Left="335,73253" Top="0" Width="102,04724654" Height="11,33858268" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;PLACA&#34;]">
        <Formats>
          <item/>
          <item/>
        </Formats>
      </TfrxMemoView>
      <TfrxMemoView Name="Memo12" IndexTag="1" AllowVectorExport="True" Left="441,07086614" Top="0" Width="188,97637795" Height="11,33858268" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;VENDEDOR&#34;] - [SQL Mestre.&#34;NOME_VENDEDOR&#34;]"/>
    </TfrxMasterData>
    <TfrxPageFooter Name="PageFooter1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="22,67718" Left="0" Top="328,81911" Width="718,1107" OnBeforePrint="PageFooter1OnBeforePrint">
      <TfrxMemoView Name="TotalPages" AllowVectorExport="True" Left="609,50433" Top="3,77954465" Width="102,04731" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Page#] / [TotalPages#]"/>
      <TfrxMemoView Name="MmFooterWLE" AllowVectorExport="True" Left="3,77953" Top="12,77953" Width="600,94527" Height="11,33859" Font.Charset="1" Font.Color="0" Font.Height="-5" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text=""/>
    </TfrxPageFooter>
    <TfrxPageHeader Name="PageHeader1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="88,81894646" Left="0" Top="18,89765" Width="718,1107">
      <TfrxMemoView Name="Memo2" AllowVectorExport="True" Left="449,76407" Top="22,67718" Width="94,48825" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="Data:"/>
      <TfrxMemoView Name="Date" AllowVectorExport="True" Left="551,81138" Top="22,67718" Width="86,92919" Height="18,89765" Font.Charset="1" Font.Color="-16777208" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[Date]"/>
      <TfrxMemoView Name="Time" AllowVectorExport="True" Left="646,29963" Top="22,67718" Width="68,03154" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Time]"/>
      <TfrxLineView Name="Line2" AllowVectorExport="True" Left="3,77953" Top="68,03154" Width="710,55164" Height="0" Color="0" Frame.Typ="4"/>
      <TfrxMemoView Name="RetornaEmpresa" AllowVectorExport="True" Left="7,55906" Top="22,67718" Width="434,64595" Height="18,89765" Frame.Typ="0" Text="[RetornaEmpresa('RELATORIO')]"/>
      <TfrxMemoView Name="RetornaEmpresa1" AllowVectorExport="True" Left="7,55906" Top="0" Width="438,42548" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="[RetornaEmpresa('DESCRICAO')]"/>
      <TfrxMemoView Name="RetornaEmpresa2" AllowVectorExport="True" Left="449,76407" Top="0" Width="264,5671" Height="18,89765" Frame.Typ="0" HAlign="haRight" Text="[RetornaEmpresa('NUMEROINSCRICAO')]"/>
      <TfrxMemoView Name="Memo1" AllowVectorExport="True" Left="3,77953" Top="49,13389" Width="464,88219" Height="18,89765" Frame.Typ="0" Text="PerÃ­odo: [RetornaParametro('DATA_INI')] Ã  [RetornaParametro('DATA_FIM')]">
        <Formats>
          <item/>
          <item/>
        </Formats>
      </TfrxMemoView>
      <TfrxMemoView Name="Memo6" AllowVectorExport="True" Left="119,40928528" Top="71,81107" Width="113,38582677" Height="15,11811024" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="8" ParentFont="False" Text="EmissÃ£o"/>
      <TfrxMemoView Name="Memo7" AllowVectorExport="True" Left="234,68522" Top="71,81107" Width="98,26771654" Height="15,11811024" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="8" ParentFont="False" Text="NÃºmero / SÃ©rie"/>
      <TfrxMemoView Name="Memo8" AllowVectorExport="True" Left="633,07086614" Top="71,81107" Width="81,25984252" Height="15,1181102362205" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Total"/>
      <TfrxMemoView Name="Memo9" AllowVectorExport="True" Left="441,20501" Top="71,81107" Width="188,9762852" Height="15,11811024" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="8" ParentFont="False" Text="Vendedor"/>
      <TfrxMemoView Name="Memo10" AllowVectorExport="True" Left="335,73253" Top="71,81107" Width="102,0470952" Height="15,11811024" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="8" ParentFont="False" Text="Placa"/>
    </TfrxPageHeader>
    <TfrxGroupHeader Name="GroupHeader1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="18,89765" Left="0" Top="170,07885" Width="718,1107" OnAfterPrint="GroupHeader1OnAfterPrint" Condition="SQL Mestre.&#34;GRUPO&#34;">
      <TfrxMemoView Name="SQLMestrePLACA" IndexTag="1" AllowVectorExport="True" Left="3,77953" Top="0" Width="559,37044" Height="18,89765" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-15" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="Grupo: [SQL Mestre.&#34;GRUPO&#34;] - [SQL Mestre.&#34;NOME&#34;]"/>
    </TfrxGroupHeader>
    <TfrxGroupFooter Name="GroupFooter1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Height="22,67718" Left="0" ParentFont="False" Top="245,66945" Width="718,1107">
      <TfrxMemoView Name="Memo3" AllowVectorExport="True" Left="380,73253" Top="0" Width="241,88992" Height="15,11812" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" Frame.Width="0,5" HAlign="haRight" ParentFont="False" Text="Total Grupo [SQL Mestre.&#34;NOME&#34;]:"/>
      <TfrxMemoView Name="Memo4" AllowVectorExport="True" Left="624,62245" Top="0" Width="90,70872" Height="15,11811024" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" Frame.Width="0,5" HAlign="haRight" ParentFont="False" Text="[Arredonda(SUM(&#60;SQL Mestre.&#34;TOTAL_GRUPO&#34;&#62;,MasterData1),2)]"/>
    </TfrxGroupFooter>
  </TfrxReportPage>
</TfrxReport>
