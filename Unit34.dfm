object Form34: TForm34
  Left = 378
  Top = 96
  ActiveControl = etFind
  Caption = 'Form34'
  ClientHeight = 546
  ClientWidth = 1025
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 43
    Width = 237
    Height = 489
    ImeName = 'Microsoft IME 2010'
    Lines.Strings = (
      #50640#49828#54532#47112#49548
      #52852#54168#46972#46524'-G'
      #52852#54168#46972#46524'-S'
      #52852#54392#52824#45432'-G'
      #52852#54392#52824#45432'-S'
      'Hot-'#49828#54168#49500#54000'-'#49884#45796#47784'-G'
      'Hot-'#49828#54168#49500#54000'-'#49884#45796#47784'-S'
      'Hot-'#49828#54168#49500#54000'-'#50500#44396#50500#54624'-G'
      'Hot-'#49828#54168#49500#54000'-'#50500#44396#50500#54624'-S'
      'Hot-'#49828#54168#49500#54000'-'#54252#47784#49324'-G'
      'Hot-'#49828#54168#49500#54000'-'#54252#47784#49324'-S'
      'Ice-'#52852#54168#46972#46524'-G'
      'Ice-'#52852#54168#46972#46524'-S'
      'Ice-'#49828#54168#49500#54000'-'#49884#45796#47784'-G'
      'Ice-'#49828#54168#49500#54000'-'#49884#45796#47784'-S'
      'Ice-'#49828#54168#49500#54000#50500#44396#50500#54624'-G'
      'Ice-'#49828#54168#49500#54000'-'#50500#44396#50500#54624'-S'
      'Ice-'#49828#54168#49500#54000'-'#54252#47784#49324'-G'
      'Ice-'#49828#54168#49500#54000'-'#54252#47784#49324'-S'
      'Hot-'#49828#54168#49500#54000'-'#53412#50521#44256#51060'-S'
      'Hot-'#49828#54168#49500#54000'-'#53412#50521#44256#51060'-G'
      'Hot-'#49828#54168#49500#54000'-'#50504#52488'-S'
      'Hot-'#49828#54168#49500#54000'-'#50504#52488'-G'
      'Hot-'#49828#54168#49500#54000'-'#44172#51060#49380'-S'
      'Hot-'#49828#54168#49500#54000'-'#44172#51060#49380'-G'
      'Ice-'#49828#54168#49500#54000'-'#53412#50521#44256#51060'-S'
      'Ice-'#49828#54168#49500#54000'-'#53412#50521#44256#51060'-G'
      'Ice-'#49828#54168#49500#54000'-'#50504#52488'-S'
      'Ice-'#49828#54168#49500#54000'-'#50504#52488'-G'
      'Ice-'#49828#54168#49500#54000'-'#44172#51060#49380'-S'
      'Ice-'#49828#54168#49500#54000'-'#44172#51060#49380'-G'
      #46972#46524' '#54532#46972#54168'-S'
      #47784#52852' '#54532#46972#54168'-S'
      #52488#53084#47551' '#54532#46972#54168'-S'
      #44536#47536#54000' '#54532#46972#54168'-S'
      #49828#53944#47196#48288#47532' '#54532#46972#54168'-S'
      #54660#52824#51592' '#48148#44172#53944' '#49464#53944
      #52852#54532#47112#51228' '#48148#44172#53944' '#49464#53944
      #50672#50612'/'#53356#47548#52824#51592' '#48148#44172#53944' '#49464#53944
      'Hot-'#50640#49828#54532#47112#49548'-'#48652#46972#51656
      'Hot-'#50640#49828#54532#47112#49548'-'#50640#54000#50724#54588#50500
      'Hot-'#50640#49828#54532#47112#49548'-'#44284#53580#47568#46972
      'Hot-'#50640#49828#54532#47112#49548'-'#54028#45208#47560
      'Hot-'#50640#49828#54532#47112#49548'-'#52992#45264
      'Hot-'#50640#49828#54532#47112#49548'-'#44172#51060#49380
      #52824#53416'&'#53356#47004#48288#47532' '#48148#44172#53944'('#45800#54408')'
      #52824#53416'/'#53356#47004#48288#47532' '#48148#44172#53944' '#49464#53944
      'Hot-'#49828#54168#49500#54000'-'#44264#46304#50952#53552'-S'
      'Hot-'#49828#54168#49500#54000'-'#44264#46304#50952#53552'-G'
      'Ice-'#49828#54168#49500#54000'-'#44264#46304#50952#53552'-S'
      'Ice-'#49828#54168#49500#54000'-'#44264#46304#50952#53552'-G')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 251
    Top = 12
    Width = 113
    Height = 25
    Caption = #51088#46041#50756#49457#50857#51900#44060#44592
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 506
    Top = 43
    Width = 249
    Height = 489
    ImeName = 'Microsoft IME 2010'
    Lines.Strings = (
      'Memo2')
    TabOrder = 2
  end
  object etFind: TEdit
    Left = 761
    Top = 16
    Width = 249
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 3
    OnKeyUp = etFindKeyUp
  end
  object Button3: TButton
    Left = 506
    Top = 12
    Width = 113
    Height = 25
    Caption = #52488#49457#44160#49353#50857' '#52628#52636
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 390
    Top = 12
    Width = 110
    Height = 25
    Caption = #51900#44064#53581#49828#53944' '#54633#52824#44592
    TabOrder = 5
    OnClick = Button4Click
  end
  object ListBox1: TListBox
    Left = 761
    Top = 43
    Width = 249
    Height = 491
    ImeName = 'Microsoft IME 2010'
    ItemHeight = 13
    TabOrder = 6
    Visible = False
  end
  object Memo3: TMemo
    Left = 251
    Top = 43
    Width = 249
    Height = 489
    ImeName = 'Microsoft IME 2010'
    Lines.Strings = (
      'Memo2')
    TabOrder = 7
  end
  object Button5: TButton
    Left = 8
    Top = 12
    Width = 129
    Height = 25
    Caption = 'Source'#47700#47784#47532#50640#50732#47532#44592
    TabOrder = 8
    OnClick = Button5Click
  end
end
