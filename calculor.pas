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
    edtInput: TEdit; // Edit 控件，用于显示和输入数字
    lblOutput: TLabel;
    pnlDel: TPanel; // Label 控件，用于显示操作过程和结果
    procedure pnlNum0Click(Sender: TObject); // 处理点击数字按钮事件
    procedure pnlNumClick(Sender: TObject); // 处理点击数字按钮事件
    procedure pnlCClick(Sender: TObject); // 处理清空按钮事件
    procedure pnlDotClick(Sender: TObject); // 处理小数点按钮事件
    procedure pnlBioClick(Sender: TObject); // 处理运算符按钮事件
    procedure pnlEqualClick(Sender: TObject); // 处理等号按钮事件
    function calculate(currentopt: string; currentNum, lastNum: Extended): Extended; // 执行计算
    procedure FormCreate(Sender: TObject);
    procedure pnlDelClick(Sender: TObject); // 窗体创建时的初始化操作
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CalculatorForm: TCalculatorForm;

function IsBinaryOperator(symb1: string): Boolean; // 判断字符是否是二元运算符

implementation

{$R *.dfm}

var
  currentNum, lastNum: Extended; // 当前数字和上一个数字
  currentopt: string; // 当前运算符
  isEqualed: Boolean; //点击数字时是否已经点击了'='
  isCalculated: Boolean; //已经计算过

procedure TCalculatorForm.pnlEqualClick(Sender: TObject);
begin
  // 检查是否输入为空
  if edtInput.Text = '' then
  begin
    edtInput.Text := FloatToStr(lastNum);
  end
  else if not isEqualed then
  begin
    // 获取当前输入的数字
    currentNum := StrToFloat(edtInput.Text);
    // 计算结果并显示
    lastNum := calculate(currentopt, currentNum, lastNum);
    edtInput.Text := FloatToStr(lastNum);
  end;
  currentopt := '+';
  // 重置上一个数字和输出标签
  lastNum := 0;
  //将是否点击了‘=’置为true
  isEqualed := True;
  lblOutput.Caption := '';
end;

procedure TCalculatorForm.FormCreate(Sender: TObject);
begin
  // 初始化当前运算符为 '+'
  currentopt := '+';
  //初始化为false
  isEqualed := False;
   //初始化为false
  isCalculated := False;
end;

procedure TCalculatorForm.pnlBioClick(Sender: TObject);
begin
  if not isCalculated then
  begin
    // 获取当前输入的数字
    currentNum := StrToFloat(edtInput.Text);
  // 计算结果并更新当前运算符
    lastNum := calculate(currentopt, currentNum, lastNum);
    currentopt := TButton(Sender).Caption;
  // 更新输出标签显示当前操作过程
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
  // 根据当前运算符执行相应的计算操作
  if currentopt = '+' then
  begin
    result := lastNum + currentNum;
  end
  else if currentopt = '-' then
  begin
    result := lastNum - currentNum;
  end
  else if currentopt = '×' then
  begin
    result := lastNum * currentNum;
  end
  else if currentopt = '÷' then
  begin
  //检查除数是否为零
    if currentNum <> 0 then
    begin
      result := lastNum / currentNum
    end
    else
    begin
        // 如果除数为零，可以选择抛出异常或者返回一个特定的值
      // 这里选择抛出异常
      raise Exception.Create('除数不能为零');

    end;
  end
  else
    Result := lastNum;

end;

procedure TCalculatorForm.pnlNum0Click(Sender: TObject);
begin

  // 处理数字按钮点击事件
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
//没有点击‘=’按钮
  if not isEqualed then
  // 处理数字按钮点击事件
    edtInput.Text := edtInput.Text + TButton(Sender).Caption
  else
  begin
    edtInput.Text := '' + TButton(Sender).Caption;
  //置为false
    isEqualed := False;

  end;
  isCalculated := False;
end;

procedure TCalculatorForm.pnlCClick(Sender: TObject);
begin
  // 清空输入框和输出标签
  edtInput.Text := '';
  lblOutput.Caption := '';

  // 重置计算器状态
  currentopt := '+';
  lastNum := 0;
  currentNum := 0;
end;

procedure TCalculatorForm.pnlDelClick(Sender: TObject);
begin
  // 删除最近一位字符
  if Length(edtInput.Text) > 0 then
    edtInput.Text := Copy(edtInput.Text, 1, Length(edtInput.Text) - 1);
end;

procedure TCalculatorForm.pnlDotClick(Sender: TObject);
begin
  // 获取当前编辑框中文本的长度，如果长度不为 0 并且edt中不包含'.'，则添加小数点
  if (Length(edtInput.Text) <> 0) and (Pos('.', edtInput.Text) = 0) then
    edtInput.Text := edtInput.Text + '.';

end;

function IsBinaryOperator(symb1: string): Boolean;
begin
  // 判断字符是否是二元运算符
  Result := (symb1 = '+') or (symb1 = '-') or (symb1 = '×') or (symb1 = '÷');
end;

end.

