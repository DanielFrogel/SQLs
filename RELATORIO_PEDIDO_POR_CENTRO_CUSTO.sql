SELECT 
    
    P.NUMERO,
    CAST(CC.CODIGO AS VARCHAR(8)) AS CENTRO_CUSTO,
    CC.DESCRICAO AS CC_DESCRICAO, 
    P.EMISSAO, 
    PP.PRODUTO,
    PP.QUANTIDADE, 
    CAST(PP.DESCRICAO AS VARCHAR(80)) PP_DESCRICAO, 
    PP.UNITARIO, 
    PP.TOTAL 
        
FROM PEDIDOS P

    INNER JOIN PEDIDOPRODUTOS PP ON (P.NUMERO = PP.PEDIDO)
    LEFT JOIN CENTROCUSTO CC ON (P.CENTRO_CUSTO = CC.CODIGO)
    
WHERE

	P.EMISSAO BETWEEN :DATA_INI AND :DATA_FIM AND
	PP.PRODUTO LIKE '%' || :PRODUTO AND
	CC.CODIGO LIKE '%' || :CENTRO_CUSTO

ORDER BY &ORDEM

-- PARAMETER:'DATA_INI';TYPE:'DATE';DESCRIPTION:'Data de Emissão';DEFAULT:'HOJE'
-- PARAMETER:'DATA_FIM';TYPE:'DATE';DESCRIPTION:'até';DEFAULT:'HOJE'
-- PARAMETER:'PRODUTO';TYPE:'TEXT';DESCRIPTION:'Produto';SIZE:020;FORMAT:'PRODUTO';BUTTON:'PRODUTOS';ZEROS:'NAO'
-- PARAMETER:'CENTRO_CUSTO';TYPE:'TEXT';DESCRIPTION:'Centro de Custo';SIZE:050;FORMAT:'CENTRO_CUSTO';BUTTON:'CENTROCUSTO';ZEROS:'NAO'

-- ORDER:'P.NUMERO';DESCRIPTION:'Número do Pedido'
-- ORDER:'CC.CODIGO';DESCRIPTION:'Código do Centro de Custo'
-- ORDER:'CC.DESCRICAO';DESCRIPTION:'Descrição do Centro de Custo'
-- ORDER:'PP_DESCRICAO';DESCRIPTION:'Descrição do Produto'
-- ORDER:'PP.QUANTIDADE';DESCRIPTION:'Quantidade do Produto'<?xml version="1.0" encoding="utf-8" standalone="no"?>
<TfrxReport Version="6.9.14" DotMatrixReport="False" IniFile="c:\wle_sistemas\Fast Reports" PreviewOptions.Buttons="4095" PreviewOptions.Zoom="1" PrintOptions.Printer="Padr?o" PrintOptions.PrintOnSheet="0" ReportOptions.CreateDate="41901,4571771412" ReportOptions.Description.Text="" ReportOptions.LastChange="45274,3772106713" ScriptLanguage="PascalScript" ScriptText.Text="procedure PageFooter1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;&#13;&#10;   MmFooterWLE.text := 'Â© WLE Tecnologia em AutomaÃ§Ã£o - '+FormatDateTime('YYYY', DATE)+' | MATRIZ - UniÃ£o da VitÃ³ria/PR: (41)4042-9777 | Unidade Ponta Grossa/PR: (42)3225-5839 | Unidade Mafra/SC: (47) 3645-1480 ';&#13;&#10;end;&#13;&#10;&#13;&#10;procedure MasterData1OnBeforePrint(Sender: TfrxComponent);&#13;&#10;begin&#13;&#10;  SQLMestreCENTRO_CUSTO.Text := Copy(&#60;SQL Mestre.&#34;CENTRO_CUSTO&#34;&#62;, 1, 2) + '.' + Copy(&#60;SQL Mestre.&#34;CENTRO_CUSTO&#34;&#62;, 3, 2) + '.' + Copy(&#60;SQL Mestre.&#34;CENTRO_CUSTO&#34;&#62;, 5, 4);                                                              &#13;&#10;     &#13;&#10;end;&#13;&#10;&#13;&#10;begin&#13;&#10;&#13;&#10;end.">
  <Datasets>
    <item DataSet="DataSetMaster" DataSetName="SQL Mestre"/>
  </Datasets>
  <TfrxDataPage Name="Data" HGuides.Text="" VGuides.Text="" Height="1000" Left="0" Top="0" Width="1000"/>
  <TfrxReportPage Name="Page1" HGuides.Text="" VGuides.Text="" Orientation="poLandscape" PaperWidth="297" PaperHeight="210" PaperSize="9" LeftMargin="10" RightMargin="10" TopMargin="10" BottomMargin="10" ColumnWidth="0" ColumnPositions.Text="" Frame.Typ="0" MirrorMode="0">
    <TfrxMasterData Name="MasterData1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="13,22834646" Left="0" Top="166,29932" Width="1046,92981" OnBeforePrint="MasterData1OnBeforePrint" ColumnWidth="0" ColumnGap="0" DataSet="DataSetMaster" DataSetName="SQL Mestre" RowCount="0">
      <TfrxMemoView Name="SQLMestreNUMERO" IndexTag="1" AllowVectorExport="True" Left="3,77953" Top="0" Width="64,25201" Height="13,22834646" DataField="NUMERO" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;NUMERO&#34;]"/>
      <TfrxMemoView Name="SQLMestreCENTRO_CUSTO" IndexTag="1" AllowVectorExport="True" Left="68,03154" Top="0" Width="79,37013" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;CENTRO_CUSTO&#34;]"/>
      <TfrxMemoView Name="SQLMestreCC_DESCRICAO" IndexTag="1" AllowVectorExport="True" Left="147,40167" Top="0" Width="309,92146" Height="13,22834646" DataField="CC_DESCRICAO" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;CC_DESCRICAO&#34;]"/>
      <TfrxMemoView Name="SQLMestreEMISSAO" IndexTag="1" AllowVectorExport="True" Left="457,32313" Top="0" Width="83,14966" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="mm/dd/yyyy" DisplayFormat.Kind="fkDateTime" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;EMISSAO&#34;]"/>
      <TfrxMemoView Name="SQLMestrePP_DESCRICAO" IndexTag="1" AllowVectorExport="True" Left="608,50433" Top="0" Width="230,55133" Height="13,22834646" DataField="PP_DESCRICAO" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;PP_DESCRICAO&#34;]"/>
      <TfrxMemoView Name="SQLMestreQUANTIDADE" IndexTag="1" AllowVectorExport="True" Left="839,05566" Top="0" Width="56,69295" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;QUANTIDADE&#34;]"/>
      <TfrxMemoView Name="SQLMestreUNITARIO" IndexTag="1" AllowVectorExport="True" Left="895,74861" Top="0" Width="68,03154" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;UNITARIO&#34;]"/>
      <TfrxMemoView Name="SQLMestreTOTAL" IndexTag="1" AllowVectorExport="True" Left="963,78015" Top="0" Width="79,37013" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;TOTAL&#34;]"/>
      <TfrxMemoView Name="SQLMestrePRODUTO" IndexTag="1" AllowVectorExport="True" Left="540,47279" Top="0" Width="68,03154" Height="13,22834646" DataField="PRODUTO" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;PRODUTO&#34;]"/>
    </TfrxMasterData>
    <TfrxPageFooter Name="PageFooter1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="22,67718" Left="0" Top="294,80334" Width="1046,92981" OnBeforePrint="PageFooter1OnBeforePrint">
      <TfrxMemoView Name="TotalPages" AllowVectorExport="True" Left="934,54391" Top="3,77954465" Width="102,04731" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Page#] / [TotalPages#]"/>
      <TfrxMemoView Name="MmFooterWLE" AllowVectorExport="True" Left="3,77953" Top="12,77953" Width="929,76438" Height="11,33859" Font.Charset="1" Font.Color="0" Font.Height="-5" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text=""/>
    </TfrxPageFooter>
    <TfrxPageHeader Name="PageHeader1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="85,03941646" Left="0" Top="18,89765" Width="1046,92981">
      <TfrxMemoView Name="Memo2" AllowVectorExport="True" Left="771,02412" Top="22,67718" Width="94,48825" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="Data:"/>
      <TfrxMemoView Name="Date" AllowVectorExport="True" Left="873,07143" Top="22,67718" Width="86,92919" Height="18,89765" Font.Charset="1" Font.Color="-16777208" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[Date]"/>
      <TfrxMemoView Name="Time" AllowVectorExport="True" Left="967,55968" Top="22,67718" Width="68,03154" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Time]"/>
      <TfrxLineView Name="Line2" AllowVectorExport="True" Left="3,77953" Top="45,35436" Width="1039,37075" Height="0" Color="0" Frame.Typ="4"/>
      <TfrxMemoView Name="RetornaEmpresa" AllowVectorExport="True" Left="7,55906" Top="22,67718" Width="434,64595" Height="18,89765" Frame.Typ="0" Text="[RetornaEmpresa('RELATORIO')]"/>
      <TfrxMemoView Name="RetornaEmpresa1" AllowVectorExport="True" Left="7,55906" Top="0" Width="680,3154" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="[RetornaEmpresa('DESCRICAO')]"/>
      <TfrxMemoView Name="RetornaEmpresa2" AllowVectorExport="True" Left="771,02412" Top="0" Width="264,5671" Height="18,89765" Frame.Typ="0" HAlign="haRight" Text="[RetornaEmpresa('NUMEROINSCRICAO')]"/>
      <TfrxMemoView Name="Memo1" IndexTag="1" AllowVectorExport="True" Left="3,77953" Top="71,81107" Width="64,25201" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="8" ParentFont="False" Text="Pedido"/>
      <TfrxMemoView Name="Memo3" IndexTag="1" AllowVectorExport="True" Left="68,03154" Top="71,81107" Width="389,29159" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="8" ParentFont="False" Text="Centro de Custo"/>
      <TfrxMemoView Name="Memo5" IndexTag="1" AllowVectorExport="True" Left="457,32313" Top="71,81107" Width="83,14966" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="mm/dd/yyyy" DisplayFormat.Kind="fkDateTime" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="8" ParentFont="False" Text="EmissÃ£o"/>
      <TfrxMemoView Name="Memo6" IndexTag="1" AllowVectorExport="True" Left="608,50433" Top="71,81107" Width="230,55133" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-9" Font.Name="Arial" Font.Style="1" Frame.Typ="8" ParentFont="False" Text=""/>
      <TfrxMemoView Name="Memo7" IndexTag="1" AllowVectorExport="True" Left="839,05566" Top="71,81107" Width="56,69295" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Quant."/>
      <TfrxMemoView Name="Memo8" IndexTag="1" AllowVectorExport="True" Left="895,74861" Top="71,81107" Width="68,03154" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="UnitÃ¡rio"/>
      <TfrxMemoView Name="Memo9" IndexTag="1" AllowVectorExport="True" Left="963,78015" Top="71,81107" Width="79,37013" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Total"/>
      <TfrxMemoView Name="Memo10" IndexTag="1" AllowVectorExport="True" Left="540,47279" Top="71,81107" Width="68,03154" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="8" ParentFont="False" Text="Produto"/>
    </TfrxPageHeader>
    <TfrxFooter Name="Footer1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="28,34645914" Left="0" Top="204,09462" Width="1046,92981">
      <TfrxMemoView Name="Memo11" IndexTag="1" AllowVectorExport="True" Left="718,1107" Top="11,33858268" Width="117,16543" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="1" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="Total Quantidade:"/>
      <TfrxMemoView Name="Memo12" IndexTag="1" AllowVectorExport="True" Left="835,27613" Top="11,33858268" Width="60,47248" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;QUANTIDADE&#34;&#62;,MasterData1,2)]"/>
      <TfrxMemoView Name="Memo13" IndexTag="1" AllowVectorExport="True" Left="899,52814" Top="11,3385826771654" Width="64,25201" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="1" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="Total:"/>
      <TfrxMemoView Name="Memo14" IndexTag="1" AllowVectorExport="True" Left="963,78015" Top="11,3385826771654" Width="79,37013" Height="13,22834646" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.FormatStr="%2.2n" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-12" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;TOTAL&#34;&#62;,MasterData1,2)]"/>
    </TfrxFooter>
  </TfrxReportPage>
</TfrxReport>
