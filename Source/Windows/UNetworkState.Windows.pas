unit UNetworkState.Windows;

interface

{$IFDEF MSWINDOWS}


uses
  System.SysUtils, System.Messaging, System.Classes, UNetworkState, Winapi.Windows, Winapi.WinInet,
  UWindowsNetworkStateMessage;

type
  TWindowsNetworkState = class(TNetworkState)
  private
  protected
    procedure DoOnConnectivityBroadcastAction(const Sender: TObject; const M: TMessage);
    function GetCurrentValue: TNetworkStateValue; override;
  public
    constructor Create(AOwner: TComponent; AOnChange: TNetworkStateChangeEvent); reintroduce; override;
    destructor Destroy; override;
  end;
{$ENDIF}

implementation

{$IFDEF MSWINDOWS}

{ TWindowsNetworkState }

constructor TWindowsNetworkState.Create(AOwner: TComponent; AOnChange: TNetworkStateChangeEvent);
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TWindowsNetworkStateMessage, DoOnConnectivityBroadcastAction);
  inherited;
end;

destructor TWindowsNetworkState.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TWindowsNetworkStateMessage, DoOnConnectivityBroadcastAction);
  inherited;
end;

procedure TWindowsNetworkState.DoOnConnectivityBroadcastAction(const Sender: TObject; const M: TMessage);
begin
  if M is TWindowsNetworkStateMessage then
    Self.DoOnChange;
end;

function TWindowsNetworkState.GetCurrentValue: TNetworkStateValue;
var
  LConnectionTypes: DWORD;
  LConnected: boolean;
begin
  LConnectionTypes :=
    INTERNET_CONNECTION_MODEM +
    INTERNET_CONNECTION_LAN +
    INTERNET_CONNECTION_PROXY+
    INTERNET_CONNECTION_MODEM_BUSY;
  LConnected := InternetGetConnectedState(@LConnectionTypes, 0);

  if LConnected then
    Result := nsUnknown
  else
    Result := nsDisconnected;
end;

{$ENDIF}

end.
