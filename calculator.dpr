program calculator;

uses
  Vcl.Forms,
  calculor in 'calculor.pas' {CalculatorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCalculatorForm, CalculatorForm);
  Application.Run;
end.
