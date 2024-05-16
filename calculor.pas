unit calculor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TCalculatorForm = class(TForm)
    pnlNum7: TPanel;
    pnlNum8: TPanel;
    pnlNum9: TPanel;
    pnlNum4: TPanel;
    pnlNum5: TPanel;
    pnlNum6: TPanel;
    pnlNum1: TPanel;
    pnlNum2: TPanel;
    pnlNum3: TPanel;
    pnlNum0: TPanel;
    pnlDot: TPanel;
    pnC: TPanel;
    pnlMul: TPanel;
    pnlDiv: TPanel;
    pnlSub: TPanel;
    pnlAdd: TPanel;
    pnlEqual: TPanel;
    edtInput: TEdit; // Edit �ؼ���������ʾ����������
    lblOutput: TLabel;
    pnlDel: TPanel; // Label �ؼ���������ʾ�������̺ͽ��
    procedure pnlNum0Click(Sender: TObject); // ����������ְ�ť�¼�
    procedure pnlNumClick(Sender: TObject); // ����������ְ�ť�¼�
    procedure pnlCClick(Sender: TObject); // ������հ�ť�¼�
    procedure pnlDotClick(Sender: TObject); // ����С���㰴ť�¼�
    procedure pnlBioClick(Sender: TObject); // �����������ť�¼�
    procedure pnlEqualClick(Sender: TObject); // �����ȺŰ�ť�¼�
    function calculate(currentopt: string; currentNum, lastNum: Extended): Extended; // ִ�м���
    procedure FormCreate(Sender: TObject);
    procedure pnlDelClick(Sender: TObject); // ���崴��ʱ�ĳ�ʼ������
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CalculatorForm: TCalculatorForm;

function IsBinaryOperator(symb1: string): Boolean; // �ж��ַ��Ƿ��Ƕ�Ԫ�����

implementation

{$R *.dfm}

var
  currentNum, lastNum: Extended; // ��ǰ���ֺ���һ������
  currentopt: string; // ��ǰ�����
  isEqualed: Boolean; //�������ʱ�Ƿ��Ѿ������'='
  isCalculated: Boolean; //�Ѿ������

procedure TCalculatorForm.pnlEqualClick(Sender: TObject);
begin
  // ����Ƿ�����Ϊ��
  if edtInput.Text = '' then
  begin
    edtInput.Text := FloatToStr(lastNum);
  end
  else if not isEqualed then
  begin
    // ��ȡ��ǰ���������
    currentNum := StrToFloat(edtInput.Text);
    // ����������ʾ
    lastNum := calculate(currentopt, currentNum, lastNum);
    edtInput.Text := FloatToStr(lastNum);
  end;
  currentopt := '+';
  // ������һ�����ֺ������ǩ
  lastNum := 0;
  //���Ƿ����ˡ�=����Ϊtrue
  isEqualed := True;
  lblOutput.Caption := '';
end;

procedure TCalculatorForm.FormCreate(Sender: TObject);
begin
  // ��ʼ����ǰ�����Ϊ '+'
  currentopt := '+';
  //��ʼ��Ϊfalse
  isEqualed := False;
   //��ʼ��Ϊfalse
  isCalculated := False;
end;

procedure TCalculatorForm.pnlBioClick(Sender: TObject);
begin
  if not isCalculated then
  begin
    // ��ȡ��ǰ���������
    currentNum := StrToFloat(edtInput.Text);
  // �����������µ�ǰ�����
    lastNum := calculate(currentopt, currentNum, lastNum);
    currentopt := TButton(Sender).Caption;
  // ���������ǩ��ʾ��ǰ��������
    lblOutput.Caption := lblOutput.Caption + edtInput.Text + TButton(Sender).Caption;
    edtInput.Text := FloatToStr(lastNum);
    isEqualed := True;
    isCalculated := True;
  end
  else
  begin
    Exit;
  end;

end;

function TCalculatorForm.calculate(currentopt: string; currentNum, lastNum: Extended): Extended;
begin
  // ���ݵ�ǰ�����ִ����Ӧ�ļ������
  if currentopt = '+' then
  begin
    result := lastNum + currentNum;
  end
  else if currentopt = '-' then
  begin
    result := lastNum - currentNum;
  end
  else if currentopt = '��' then
  begin
    result := lastNum * currentNum;
  end
  else if currentopt = '��' then
  begin
  //�������Ƿ�Ϊ��
    if currentNum <> 0 then
    begin
      result := lastNum / currentNum
    end
    else
    begin
        // �������Ϊ�㣬����ѡ���׳��쳣���߷���һ���ض���ֵ
      // ����ѡ���׳��쳣
      raise Exception.Create('��������Ϊ��');

    end;
  end
  else
    Result := lastNum;

end;

procedure TCalculatorForm.pnlNum0Click(Sender: TObject);
begin

  // �������ְ�ť����¼�
  if not isEqualed then
    edtInput.Text := edtInput.Text + TButton(Sender).Caption
  else
  begin
    edtInput.Text := '' + TButton(Sender).Caption;
    isEqualed := False;
  end;
  isCalculated := False;
 // end;

end;

procedure TCalculatorForm.pnlNumClick(Sender: TObject);
begin
//û�е����=����ť
  if not isEqualed then
  // �������ְ�ť����¼�
    edtInput.Text := edtInput.Text + TButton(Sender).Caption
  else
  begin
    edtInput.Text := '' + TButton(Sender).Caption;
  //��Ϊfalse
    isEqualed := False;

  end;
  isCalculated := False;
end;

procedure TCalculatorForm.pnlCClick(Sender: TObject);
begin
  // ��������������ǩ
  edtInput.Text := '';
  lblOutput.Caption := '';

  // ���ü�����״̬
  currentopt := '+';
  lastNum := 0;
  currentNum := 0;
end;

procedure TCalculatorForm.pnlDelClick(Sender: TObject);
begin
  // ɾ�����һλ�ַ�
  if Length(edtInput.Text) > 0 then
    edtInput.Text := Copy(edtInput.Text, 1, Length(edtInput.Text) - 1);
end;

procedure TCalculatorForm.pnlDotClick(Sender: TObject);
begin
  // ��ȡ��ǰ�༭�����ı��ĳ��ȣ�������Ȳ�Ϊ 0 ����edt�в�����'.'��������С����
  if (Length(edtInput.Text) <> 0) and (Pos('.', edtInput.Text) = 0) then
    edtInput.Text := edtInput.Text + '.';

end;

function IsBinaryOperator(symb1: string): Boolean;
begin
  // �ж��ַ��Ƿ��Ƕ�Ԫ�����
  Result := (symb1 = '+') or (symb1 = '-') or (symb1 = '��') or (symb1 = '��');
end;

end.
