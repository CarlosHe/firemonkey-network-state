unit UWindowsNetworkStateService;

interface

uses
  System.Classes, Winapi.WinInet, Winapi.Windows, System.Messaging,
  UWindowsNetworkStateMessage, System.SysUtils, FMX.Forms;

type
  TWindowsNetworkStateService = class
  private
    { private declarations }
    FThreadNetworkStateService: TThread;
    FConnected: Boolean;
  protected
    { protected declarations }
    procedure DoNetworkStateService;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure Terminate;
    procedure Start;
    function WairFor: Cardinal;
  end;

var
  WindowsNetworkStateService: TWindowsNetworkStateService;

implementation

{ TWindowsNetworkStateService }

constructor TWindowsNetworkStateService.Create;
begin
  FThreadNetworkStateService := TThread.CreateAnonymousThread(DoNetworkStateService);
  {$IFDEF MSWINDOWS}
  {$WARN SYMBOL_PLATFORM OFF}
  FThreadNetworkStateService.Priority := TThreadPriority.tpLowest;
  {$WARN SYMBOL_PLATFORM ON}
  {$ENDIF}
  FThreadNetworkStateService.FreeOnTerminate := False;

  FConnected := True;
end;

destructor TWindowsNetworkStateService.Destroy;
begin
  Terminate;
  WairFor;
  FreeAndNil(FThreadNetworkStateService);
  inherited;
end;

procedure TWindowsNetworkStateService.DoNetworkStateService;
var
  LConnectionTypes: DWORD;
  LConnected: Boolean;
begin
  while not TThread.CheckTerminated do
  begin
    LConnectionTypes :=
      INTERNET_CONNECTION_MODEM +
      INTERNET_CONNECTION_LAN +
      INTERNET_CONNECTION_PROXY +
      INTERNET_CONNECTION_MODEM_BUSY;
    LConnected := InternetGetConnectedState(@LConnectionTypes, 0);

    if LConnected <> FConnected then
    begin
      FConnected := LConnected;
      TMessageManager.DefaultManager.SendMessage(nil, TWindowsNetworkStateMessage.Create);
    end;

    TThread.Sleep(10);
  end;
end;

procedure TWindowsNetworkStateService.Start;
begin
  FThreadNetworkStateService.Start;
end;

procedure TWindowsNetworkStateService.Terminate;
begin
  FThreadNetworkStateService.Terminate;
end;

function TWindowsNetworkStateService.WairFor: Cardinal;
begin
  Result := FThreadNetworkStateService.WaitFor;
end;

initialization

WindowsNetworkStateService := TWindowsNetworkStateService.Create;
WindowsNetworkStateService.Start;

finalization

FreeAndNil(WindowsNetworkStateService);

end.
