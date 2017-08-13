unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Vcl.ExtCtrls, Data.Bind.Components, Vcl.StdCtrls, REST.Client,
  Data.Bind.ObjectScope, System.ImageList, Vcl.ImgList;

type
  TfrmMain = class(TForm)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    lblBTCPrice: TLabel;
    tmrGetBTCPrice: TTimer;
    imgArrow: TImage;
    ImageList: TImageList;
    procedure tmrGetBTCPriceTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblBTCPriceClick(Sender: TObject);
  private
    { Private declarations }
    extPreviousValue: extended;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  extPreviousValue := 0;
  tmrGetBTCPriceTimer(Self);
  tmrGetBTCPrice.Enabled := True;
end;

procedure TfrmMain.lblBTCPriceClick(Sender: TObject);
begin
  try
    tmrGetBTCPrice.Enabled := False;
    Close;
  except on E:Exception do
    ShowMessage(E.Message);
  end;
end;

procedure TfrmMain.tmrGetBTCPriceTimer(Sender: TObject);
var extCurrentValue: extended;
begin
  try
    RESTRequest.Execute;
    imgArrow.Picture.Bitmap := nil;
    if TryStrToFloat(RESTResponse.JSONValue.Value,extCurrentValue) then begin
      if (extPreviousValue > 0) then begin
        if extCurrentValue > extPreviousValue then begin
          ImageList.GetBitmap(1,imgArrow.Picture.Bitmap);
          lblBTCPrice.Font.Color := clMoneyGreen
        end else begin
          ImageList.GetBitmap(0,imgArrow.Picture.Bitmap);
          lblBTCPrice.Font.Color := clWebSalmon;
        end;
      end;
      lblBTCPrice.Caption := Format('$%s',[RESTResponse.JSONValue.Value]);
      extPreviousValue := extCurrentValue;
    end;
  except on E:Exception do
    ShowMessage(E.Message);
  end;
end;

end.
