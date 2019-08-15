program DelphiNetworkStateSample;

uses
  System.StartUpCopy,
  FMX.Forms,
  FForm in 'FForm.pas' {FormSample},
  UNetworkState in '..\Source\UNetworkState.pas',
  UBroadcastReceiver in '..\Source\Android\BroadcastReceiver\UBroadcastReceiver.pas',
  UNetworkStateBroadcastReceiver in '..\Source\Android\BroadcastReceiver\UNetworkStateBroadcastReceiver.pas',
  UNetworkState.Android in '..\Source\Android\UNetworkState.Android.pas',
  CaptiveNetwork in '..\Source\iOS\CaptiveNetwork.pas',
  SCNetworkReachability in '..\Source\iOS\SCNetworkReachability.pas',
  UNetworkState.iOS in '..\Source\iOS\UNetworkState.iOS.pas',
  UNetworkState.Windows in '..\Source\Windows\UNetworkState.Windows.pas',
  UWindowsNetworkStateService in '..\Source\Windows\Service\UWindowsNetworkStateService.pas',
  UWindowsNetworkStateMessage in '..\Source\Windows\Message\UWindowsNetworkStateMessage.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=True;
  Application.Initialize;
  Application.CreateForm(TFormSample, FormSample);
  Application.Run;
end.
