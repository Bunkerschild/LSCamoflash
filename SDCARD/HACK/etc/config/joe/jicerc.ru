
                         ����������������� ���� JOE
                                Joe ��� iceB

 JOE ���� ���� ���� �:
	1 - $HOME/.jicerc
	2 - /home/olli/joe-armv5/etc/joe/joerc

 ���� ���� ����� �������� ������ ����� ����� ���������� � ������ �������
 ������� ����:

 :include filename

 ������ ������: ��������� ���������� ����� (��� ����� ����� ����� ���� �������
 � ��������� ������. ����� ����, ����� NOXON, LINES, COLUMNS, DOPADDING � BAUD
 ����� ���������� � ������� ���������� �����):

 ���������� ������ ����������� �������, ������������ � �������������� ������:
 ��������� �������� ������������� ���� � ������ �������.

 ���������� �����
   bold (�������) inverse (��������) blink (��������) 
   dim (�����������) underline (�������������) italic (?????)
   white (�����) cyan (���������) magenta (����������) blue (�����) 
   yellow (������) green (�������) red (�������) black (������)
 ��� ����
   bg_white bg_cyan bg_magenta bg_blue bg_yellow bg_green bg_red bg_black

 ������ ��������� �����: ��. syntax/c.jsf

 ���������� ���� ��� ���� ������� ������ Idle:
   =Idle red

 ���������� ���� Idle ������ ��� ��������������� ����� ����� �:
   =c.Idle red

 ��������� ������ ���� �� c.jsf.  ������� ������ ������� - ��. � ��������� �������������� ������.

 =Idle
 =Bad        bold red
 =Preproc    blue
 =Define     bold blue
 =IncLocal   cyan
 =IncSystem  bold cyan
 =Constant   cyan
 =Escape     bold cyan
 =Type       bold
 =Keyword    bold
 =CppKeyword bold
 =Brace      magenta
 =Control

 ���������� �����, ������� ������ ����������, ������� � ������ �������:

 -option	��������� �����
 --option	����� �����

 -help_is_utf8	����������, ���� ����� ��������� - � ��������� UTF-8.  ����� ����� ���������, ��� ��� -
		� ������� 8-������ ���������.

 -mid		��� ���������� ��������� ������������� �������
 -left nn	Amount to jump left when scrolling is necessary (-1 for 1/4 width)
 -right nn	Amount to jump right when scrolling is necessary (-1 for 1/4 width)

 -marking	������������ ����� ����� ������� ����� � �������� 
                (����������� ������ � -lightoff)

-asis		������� � ������ 128 - 255 ���������� ��� ��������������

 -force		������������� ������������� ������� ������ � ����� �����

 -nolocks	���� �� ������� ������������ ���������� ������

 -nomodcheck	��������� ������������� �������� - �� ���� �� ���� �� ����� �����, ��� � ������.
		(��� ���������� ���� �������� ��� ����� ������������ - ���� �������� �� �������
		������ �����).

 -nocurdir	�� ��������� ������� ���������� � ������ �����

 -nobackups	���� �� �������, ����� ����������� ��������� �����

 -nodeadjoe	If you don't want DEADJOE files to be created

 -break_hardlinks
		������� ���� ����� �������, ��� ������� ������� ������
		(but don't break symbolic links).

 -break_links
		Delete file before writing, to break hard links
		and symbolic links.

 -lightoff	��������� ��������� ����� ����������� ��� ����������� �����

 -exask		����������� ������������ ����� ����� ��� ������

-beep		������� � ������ ������ � ��� ������ ������� �� �������

 -nosta		��������� ������ ���������

 -keepup	����� �������� �������� esc-������������������� %k � %c
 		� ������ ���������

 -pg nnn	���������� �����, ����������� ��� PgUp/PgDn

 -undo_keep nnn	���������� ��������� ���������, ������������ ��� ���������� "������".
		0 - ���� ���������� ��� �����������.

 -csmode	^KF ����� ����������� ������ ��������� ��� ^L

 -backpath path
		���������� ��� ���������� ��������� ������ (���� ������ ����� 'backpath' �
		'path', ��� ����������� �������� ��� ������������ ����� path).

 -floatmouse	���� �� ������ ������ ��������� ������ �� ����� ������
 
 -rtbutton	��� ���������� �������� ������������ ������ ������ ���� ������ �����

-nonotice	�� �������� copyright

 -noexmsg	Disable exiting message ("File not changed so no updated needed")

 -noxon		��������� ��������� ^S/^Q

 -orphan	�������� �������������� �����, ��������� � ���.������,
		� ������� ������, � �� � ����

 -dopadding	������������ ������� ���������� ��� ������
                (���� �� ����������� ������� �������� ���������� �������)

 -lines nnn	���������� ���-�� ����� �� ������

-baud 19200	���������� �������� ������ ��� ����������� ������������� ������

 -columns nnn	���������� ���-�� ������� �� ������

 -helpon	�������� ����� ��������� ��� �������

 -skiptop nnn	�� ������������ ������� nnn ����� ������

-notite         �� �������� ������ ������������� � ���������� ���������:
		������������� �������������� ������ ��� ������.

 -nolinefeeds	Prevent sending linefeeds to preserve screen history in terminal
                emulator's scroll-back buffer.

 -usetabs       ������������ ���������� ��� ����������� ��������� ������

-assume_color	������������, ��� �������� ������������ ���� � ��������� ANSI,
		���� ���� ��� �� ������� � �������� termcap/terminfo.

-assume_256color
		������������, ��� �������� ������������ 256 ������ � ����� xterm 
		(ESC [ 38 ; 5 ; NNN m � ESC [ 48 ; 5 ; NNN m).

-guess_non_utf8	Allow guess of non-UTF-8 file encoding in a UTF-8 locale.

 -guess_utf8	Allow guess of UTF-8 file encoding in non-UTF-8 locale.

-guess_utf16	Allow guess of UTF-16 encoding

-guess_crlf     �������������� ����� MS-DOS � �����. ������������� -crlf

-guess_indent	��������� ������� ��� ������� (��������� ��� ������).

-menu_explorer  ���������� � ���� ��� ������ ���������� (� ��������� ������ 
                ���������� ������������ � ���� � ���� �����������).

-menu_above	���� ��������� - ����/������ ����� ������������� ��� ������� �������.
		����� - ��� ���.

-transpose	���������� ������ � ��������� �� ���� ����.

 -menu_jump	������������ �� ���� ������ ����� �� ������� ������� Tab (����� 
		���� ����������, �� ������ �������� �� ������� ����� �����).

 -icase         ����� ����������������� �� ���������.

 -wrap          ����������� �����.

 -autoswap	��� ������������� ������ ������� ����� ������ � ����� �����

-joe_state     ������������ ���� ���������� ��������� ~/.joe_state

-mouse		�������� ��������� ���� � xterm. ��� ���� ������� ����� ������ ����
		����� ���������� ������, �� �������-����������� - �������� ����.
		��� ���������� ������������ � xterm ����������� � ����� �
		���������� �� ���� - �������� ������� Shift.

 -joexterm	���� �� ����������� Xterm, ���������������� ��� Joe - ��� 
		������ ����� -mouse ����� ������� (�����������/����������
		����� ����������� ���������).

-brpaste	When JOE starts, send command to the terminal emulator that
		enables "bracketed paste mode" (but only if the terminal
		seems to have the ANSI command set).  In this mode, text
		pasted into the window is bracketed with ESC [ 2 0 0 ~ and
		ESC [ 2 0 1 ~.

-pastehack	If keyboard input comes in as one block assume it's a mouse
		paste and disable autoindent and wordwrap.

 -square	����� ������������� ������

 -text_color color
		���������� ���� ��� ������.
 -status_color color
		���������� ���� ��� ������ ���������.
 -help_color color
		���������� ���� ��� ���������.
 -menu_color color
		���������� ���� ��� ����.
 -prompt_color color
		���������� ���� ��� ��������.
 -msg_color color
		���������� ���� ��� ���������.

		��������: -text_color bg_blue+white
		������������� ������� ��� � ����� ���� ��������� �����.

-restore	��������������� ���������� ������� ������� ��� �������� ������.

-search_prompting
		����������� ������� ��� ����������� �������.

 -regex		Search uses standard regular expression format (otherwise it uses
		JOE format where all special characters have to be escaped).

 ������ ����������� ������ ���������. -lmsg ���������� �����, ����������� 
 �����, � -rmsg - ������. ������ ������ ������ -rmsg - ������ ��� ���������� 
 ����. � ������� ����� �������������� ��������� ����������� ������������������:

  %t  ����� � 12-������� �������
  %u  ����� � 24-������� �������
  %T  O ��� ������ ���������, I ��� ������ �������
  %W  W ���� �������� ������� ����
  %I  A ���� �������� ����������
  %X  ��������� ������ ������������� ������
  %n  ��� �����
  %m  '(��������)' ���� ���� ��� �������
  %*  '*' ���� ���� ��� �������
  %R  ��������� ������ "������ ������"
  %r  ����� ������
  %c  ����� �������
  %o  �������� �������� � �����
  %O  �������� �������� � ����� � ����������������� ����
  %a  ��� ������� ��� ��������
  %A  ��� ������� ��� �������� � ����������������� ����
  %p  ������� ����� � ������� �������
  %l  ���-�� ����� � �����
  %k  ��������� ������-�������
  %S  '*SHELL*' ���� � ���� ����������� ����
  %M  ��������� � ������ �����
  %y  ���������
  %x  Context (first non-indented line going backwards)

 ����� ����� ������������ ��������� ����:
 
  \i  ��������
  \u  �������������
  \b  ���������� �������
  \d  ���������� �������
  \f  ��������
  \l  ?????

-lmsg \i%k%T%W%I%X %n %m%y%R %M %x
-rmsg  %S ��� %4r ��� %3c %t  ��������� - �� F1
-smsg ** Line %r Col %c Offset %o(0x%O) %e %a(0x%A) Width %w ** 
-zmsg ** Line %r Col %c Offset %o(0x%O) ** 
-xmsg \i Joe's Own Editor %v (%b) ** Type \bCtrl-K Q\b to exit or \bCtrl-K H\b for help **\i

 Key sequence hints which are displayed in various prompts.
-aborthint ^C
-helphint ^K H


 ������ ������: ��������� ��������� ����� � ����������� �� ����� �����:

 ������ ������ � �������� '*' � ������ ������� ���������� ������ �������,
 ������� ������ ��������������� ��� ������, ����� ������� ������������� 
 ������� ����������� ���������. ���� ��� ����� ������������� ����� ��� ������ 
 ����������� ��������� - ���������� ��������� �� ����������.

 ���������� ��������� ����������� ����� ����� ����� ����������� � ���������
 ������, ������������ � '+regex'. ���� ������������ ����� ���������� 
 ���������, �� ��� ����, ����� ��������� ����� ����������� � ����� -
 �� ������ ��������������� ����� ���������� ����������: � ����� �����, 
 � �����������.

 �� ������ ���������� ��������� �����:

	-cpara >#!;*/%
				Characters which can indent paragraphs.

	-cnotpara .
				Characters which begin non-paragraph lines.

	-encoding name
				���������� ��������� ����� (��������: utf-8, iso-8859-15)

	-syntax name
				���������� ��������� (����� �������� ����
				���������� 'name.jsf')

	-hex			����� 16������� ��������������

	-highlight		��������� ���������

	-smarthome		������� Home ������� ���������� ������ �
				������ ������, � ��� ��������� ������� -
				�� ������ ������������ ������

	-indentfirst		��� ���������� ������ smarthome ������� Home 
				������� ���������� ������ �� ������ 
				������������ ������ ������, � �� � �� ������

	-smartbacks		������� Backspace ������� 'istep' ��������
				���������� ������� 'indentc', ���� ������ 
				��������� �� ������ ������������ �������.

	-tab nnn		������ ���������

	-indentc nnn		������ ���������� ������� (32 - ������, 
				9 - tab)

	-istep nnn		���������� ������� �������

	-spaces			TAB ��������� �������, � �� ����������.

	-purify			���������� ������� ���� ���������� 
				(��������, ���� � ������� ������� � �������, 
				� ����������, � indentc - ������, �� ������ 
				����� ������������ � �������).

	-crlf			� �������� ����� ������ ������������  CR-LF

	-wordwrap		������� ���� 

	-autoindent		����������

	-overwrite		����� ���������

        -picture                ����� ������� (������� ������ ����� �������
        			�� ����� ������)

	-lmargin nnn		����� �������

	-rmargin nnn		������ �������

	-flowed			Put one space after intermediate paragraph lines
				for support of flowed text.


	-french			���� ������ ����� '.', '?' and '!' ��� 
				�������� ���� � �������������� ������� ������ 
				����. Joe �� �������� ������ ����� �����������
				��������, �� ������ ������ ��������� �������
				���. ���� ������ ���������� - ������� ��������
				��� ������� ���������.

	-linums			�������� ��������� �����

	-rdonly			���� ����� ������ ������

	-keymap name
				��������� ����������, ���� �� 'main'

	-lmsg			����������� ������ ��������� - ����� ��������
	-rmsg			��. ���������� ������.

	-mfirst macro
				�����, ����������� ��� ������ ����������� �����
	-mnew macro
				�����, ����������� ��� �������� ������ �����
	-mold macro
				�����, ����������� ��� �������� ������������� �����
	-msnew macro
				�����, ����������� ��� ���������� ������ �����
	-msold macro
				�����, ����������� ��� ���������� ������������� �����

        �������, ������������ � ����������� ���� ������, �����������
        ��� ��, ��� � ��������� ���������� � ����������� �������, 
        �� ��� ����� ���� ������.

	These define the language syntax for ^G (goto matching delimiter):

	-highlighter_context	Use the highlighter context for ^G

	-single_quoted		����� ������ '  ' ������� ������������ (��� ��
				����� ������ ��� �������� ������, �.�. ' � ���
				����� �������������� � �������� ���������)

	-c_comment		����� ������ /* */ ������� �������������

	-cpp_comment		����� ����� // ������� ������������

	-pound_comment		����� ����� # ������� ������������

	-vhdl_comment		����� ����� -- ������� ������������

	-semi_comment		����� ����� ; ������� ������������

	-text_delimiters begin=end:if=elif=else=endif

				���������� �����-������������

 ��������� ����� �� ���������
-highlight
-istep 4


 ����������� ��� ����� (��������� � ������ �������) ����� ��������� joe �������� 
 ������� "p4 edit" ��� ����������� �����.

 -mfirst if,"rdonly && joe(sys,\"p4 edit \",name,rtn)",then,mode,"o",msg,"executed \"p4 edit ",name,"\"",rtn,endif

 ������� ����� ������ ������ ��������� � ��������� �����. �� ������ ����������� ��� � ~/.joe � ���������.

:include ftyperc

 SECOND and 1/2 SECTION: Option menu layout

	:defmenu name [macro]
			Defines a menu.
			The macro here is executed when the user hits backspace.

	macro string comment
			A menu entry.  Macro is any JOE macro- see "Macros:"
			below. String is the label to be used for the macro
			in the menu.  It is in the same format as the -lmsg
			and -rmsg options above.

			Two whitespace characters in a row begins a comment.
			Use '% ' for a leading space in the string.

:defmenu root
mode,"overwrite",rtn	T Overtype %Zoverwrite%
mode,"hex",rtn	' Hex edit mode
mode,"autoindent",rtn	I Autoindent %Zautoindent%
mode,"wordwrap",rtn	W Word wrap %Zwordwrap%
mode,"tab",rtn	D Tab width %Ztab%
mode,"lmargin",rtn	L Left margin %Zlmargin%
mode,"rmargin",rtn	R Right margin %Zrmargin%
mode,"square",rtn	X Column mode %Zsquare%
mode,"indentc",rtn	% % Indent char %Zindentc%
mode,"istep",rtn	% % Indent step %Zistep%
menu,"indent",rtn	= Indent select
mode,"highlight",rtn	H Highlighting %Zhighlight%
mode,"crlf",rtn	Z CR-LF/MS-DOS %Zcrlf%
mode,"linums",rtn	N Line numbers %Zlinums%
mode,"hiline",rtn	U Highlight line %Zhiline%
mode,"beep",rtn	B Beep %Zbeep%
mode,"rdonly",rtn	O Read only %Zrdonly%
mode,"syntax",rtn	Y Syntax
mode,"colors",rtn	S Color scheme
mode,"encoding",rtn	E Encoding
mode,"asis",rtn	% % Meta chars as-is
mode,"language",rtn	V Language
mode,"picture",rtn	P picture %Zpicture%
mode,"type",rtn		F File type [%Ztype%]
mode,"title",rtn	C Context %Ztitle%
menu,"more-options",rtn	  % % More options...

:defmenu more-options menu,"root",rtn
menu,"^G",rtn	% % ^G options
menu,"search",rtn	% % search options
menu,"paragraph",rtn	% % paragraph options
menu,"file",rtn	% % file options
menu,"menu",rtn	% % menu options
menu,"global",rtn	% % global options
menu,"cursor",rtn	% % cursor options
menu,"marking",rtn	% % marking options
menu,"tab",rtn	% % tab/indent options

:defmenu indent menu,"root",rtn
mode,"istep",rtn,"1",rtn,mode,"indentc",rtn,"32",rtn,msg,"Indent step = 1, Indent character = 32",rtn	1 Space
mode,"istep",rtn,"2",rtn,mode,"indentc",rtn,"32",rtn,msg,"Indent step = 2, Indent character = 32",rtn	2 Spaces
mode,"istep",rtn,"3",rtn,mode,"indentc",rtn,"32",rtn,msg,"Indent step = 3, Indent character = 32",rtn	3 Spaces
mode,"istep",rtn,"4",rtn,mode,"indentc",rtn,"32",rtn,msg,"Indent step = 4, Indent character = 32",rtn	4 Spaces
mode,"istep",rtn,"5",rtn,mode,"indentc",rtn,"32",rtn,msg,"Indent step = 5, Indent character = 32",rtn	5 Spaces
mode,"istep",rtn,"8",rtn,mode,"indentc",rtn,"32",rtn,msg,"Indent step = 8, Indent character = 32",rtn	8 Spaces
mode,"istep",rtn,"10",rtn,mode,"indentc",rtn,"32",rtn,msg,"Indent step = 10, Indent character = 32",rtn	0 Ten
mode,"istep",rtn,"1",rtn,mode,"indentc",rtn,"9",rtn,msg,"Indent step = 1, Indent character = 9",rtn	T Tab

:defmenu menu menu,"more-options",rtn
mode,"menu_explorer",rtn	% % Menu explorer %Zmenu_explorer%
mode,"menu_above",rtn	% % Menu position %Zmenu_above%
mode,"menu_jump",rtn	% % Jump into menu %Zmenu_jump%
mode,"transpose",rtn	% % Transpose menus %Ztranspose%

:defmenu ^G menu,"more-options",rtn
mode,"highlighter_context",rtn	% % ^G uses highlighter context %Zhighlighter_context%
mode,"single_quoted",rtn	% % ^G ignores '...' %Zsingle_quoted%
mode,"no_double_quoted",rtn	% % ^G no ignore "..." %Zno_double_quoted%
mode,"c_comment",rtn	% % ^G ignores /*...*/ %Zc_comment%
mode,"cpp_comment",rtn	% % ^G ignores //... %Zcpp_comment%
mode,"pound_comment",rtn	% % ^G ignores #... %Zpound_comment%
mode,"vhdl_comment",rtn	% % ^G ignores --... %Zvhdl_comment%
mode,"semi_comment",rtn	% % ^G ignores ;... %Zsemi_comment%
mode,"tex_comment",rtn % % ^G ignores %%... %Ztex_comment%
mode,"text_delimiters",rtn % % Text delimiters %Ztext_delimiters%

:defmenu search menu,"more-options",rtn
mode,"icase",rtn	% % Case insensitivity %Zicase%
mode,"wrap",rtn	% % Search wraps %Zwrap%
mode,"search_prompting",rtn	% % Search prompting %Zsearch_prompting%
mode,"csmode",rtn	% % Continued search %Zcsmode%

:defmenu paragraph menu,"more-options",rtn
mode,"french",rtn	% % French spacing %Zfrench%
mode,"flowed",rtn	% % Flowed text %Zflowed%
mode,"cpara",rtn	% % Paragraph indent chars %Zcpara%
mode,"cnotpara",rtn	% % Not-paragraph chars %Zcnotpara%

:defmenu file menu,"more-options",rtn
mode,"restore",rtn	% % Restore cursor %Zrestore%
mode,"guess_crlf",rtn	% % Auto detect CR-LF %Zguess_crlf%
mode,"guess_indent",rtn	% % Guess indent %Zguess_indent%
mode,"guess_non_utf8",rtn	% % Guess non-UTF-8 %Zguess_non_utf8%
mode,"guess_utf8",rtn	% % Guess UTF-8 %Zguess_utf8%
mode,"guess_utf16",rtn	% % Guess UTF-16 %Zguess_utf16%
mode,"force",rtn	% % Force last NL %Zforce%
mode,"nobackup",rtn	% % No backup %Znobackup%

:defmenu global menu,"more-options",rtn
mode,"nolocks",rtn	% % Disable locks %Znolocks%
mode,"nobackups",rtn	% % Disable backups %Znobackups%
mode,"nodeadjoe",rtn	% % Disable DEADJOE %Znodeadjoe%
mode,"nomodcheck",rtn	% % Disable mtime check %Znomodcheck%
mode,"nocurdir",rtn	% % Disable current dir %Znocurdir%
mode,"exask",rtn	% % Exit ask %Zexask%
mode,"nosta",rtn	% % Disable status line %Znosta%
mode,"keepup",rtn	% % Fast status line %Zkeepup%
mode,"break_hardlinks",rtn	% % Break hard links %Zbreak_hardlinks%
mode,"break_links",rtn	% % Break links %Zbreak_links%
mode,"joe_state",rtn	% % Joe_state file %Zjoe_state%
mode,"undo_keep",rtn	% % No. undo records %Zundo_keep%
mode,"backpath",rtn	% % Path to backup files %Zbackpath%

:defmenu cursor menu,"more-options",rtn
mode,"pg",rtn	% % No. PgUp/PgDn lines %Zpg%
mode,"mid",rtn	C Center on scroll %Zmid%
mode,"left",rtn	L Columns to scroll left %Zleft%
mode,"right",rtn R Columns to scroll right %Zright%
mode,"floatmouse",rtn	% % Click past end %Zfloatmouse%
mode,"rtbutton",rtn	% % Right button %Zrtbutton%

:defmenu marking menu,"more-options",rtn
mode,"autoswap",rtn	% % Autoswap mode %Zautoswap%
mode,"marking",rtn	% % Marking %Zmarking%
mode,"lightoff",rtn	% % Auto unmask %Zlightoff%

:defmenu tab menu,"more-options",rtn
mode,"smarthome",rtn	% % Smart home key %Zsmarthome%
mode,"smartbacks",rtn	% % Smart backspace %Zsmartbacks%
mode,"indentfirst",rtn	% % To indent first %Zindentfirst%
mode,"purify",rtn	% % Clean up indents %Zpurify%
mode,"spaces",rtn	% % No tabs %Zspaces%

 ������ ������: ������ ���������:

 ����������� \i ��� ���/���� ��������
 ����������� \u ��� ���/���� �������������
 ����������� \b ��� ���/���� ���������� �������
 ����������� \d ��� ���/���� ���������� �������
 ����������� \f ��� ���/���� ��������
 ����������� \l ��� ���/���� ?????
 ����������� \| ��� ������� ��������: ��� �������� � ������ ��������������� 
 �� ���������� ������, ����� ������ ������������� �� ��� ������ ������ (����
 ��������� �� ���������� � �������� N ��������, �� ������ �� N �������� ������
 ����������� ��� ����� ��������). �����: ���� ��������� ������������ 
 ������������ - � ������ ������ ������ ���� ���������� ���������� ��������.

 ����������� ���������� ����� '-help_is_utf8' ����� ��������� UTF-8 � ������
 ���������. ����� �������������� ��������� 8-������ ���������.

{Basic
\i   ���� ��������� - \|��������� �� F1    ����.����� -  ^N                        \i
\i \i\|\u��������\u         \|\u��������\u         \|\u�����\u      \|\u��������\u \|\u������\u       \|\u�����\u     \|\i \i
\i \i\|^B left ^F right \|^U  prev. screen \|^KB begin  \|^D char. \|^KJ reformat \|^KX save  \|\i \i
\i \i\|\b^Z\b ����. �����  \|\bPgUp\b ����. ����� \|\bF3\b  ������  \|\bDel\b ����.\|\b^KJ\b ������   \|\bF10\b ����. \|\i \i
\i \i\|\b^X\b ����. �����  \|\bPgDn\b ����. ����� \|\bS/F3\b �����  \|\b^Y\b ���.   \|\b^T\b ������   \|\b^C\b  �����.\|\i \i
\i \i\|                \|\bHome\b ���. ������ \|\bF6\b  ������� \|\b^W\b >����� \|\b^R\b �������. \|\b^KZ\b shell \|\i \i
\i \i\|                \|\bEnd\b  ���. ������ \|\bF5\b  �����.  \|\b^O\b �����< \|\b^@\b �������  \|\u����\u      \|\i \i
\i \i\|\u�����\u           \|\bF2\b  ������ ����� \|\bS/F5\b � ���� \|\b^J\b >���.  \|\uSPELL\u     \|\b^KE\b   ����� \|\i \i
\i \i\|\bS/F7\b �� ������� \|\bS/F2\b ����� ����� \|\bS/F6\b ����.  \|\b^_\b �����. \|\b^[N\b ����� \|\b^KR\b   ������\|\i \i
\i \i\|\bF7\b   ���������  \|\b^L\b �� ������ No. \|\b^K/\b ������  \|\b^^\b �� ��� \|\b^[L\b ����� \|\bS/F10\b ������\|\i \i
}

{Windows
\i   ���� ��������� - \|��������� �� F1    ����.����� - ^P     ����. ����� ^N      \i
\i \i\b\|^KO\b ��������� ���� �������             \|\b^KE\b ��������� ���� � ����             \|\i \i
\i \i\b\|^KG\b ��������� ������� ����             \|\b^KT\b ��������� ������� ����            \|\i \i
\i \i\b\|^KN\b ������� � ������ ����              \|\b^KP\b ������� � ������� ����            \|\i \i
\i \i\b\|^C\b  ������� ������� ����               \|\b^KI\b �������� ��� ���� / ���� ����     \|\i \i
}

{Advanced
\i   ���� ��������� - \|��������� �� F1    ����.����� - ^P     ����. ����� ^N      \i
\i \i\|\u�����\u          \|\u������\u          \|\u���������\u \|\uSHELL\u       \|\uGOTO\u       \|\uI-SEARCH\u     \|\i \i
\i \i\b\|^K[ 0-9\b ������ \|\b^K\b ���� ������  \|\b^[W\b ����� \|\b^K'\b � ����  \|\b^[B\b To ^KB \|\b^[R\b �����    \|\i \i
\i \i\b\|^K]\b     �����  \|\b^K\\\b ������      \|\b^[Z\b ����  \|\b^[!\b ������� \|\b^[K\b To ^KK \|\b^[S\b ������   \|\i \i
\i \i\b\|^K 0-9\b  ������.\|\b^[M\b ����������� \|\b^K<\b ����� \|\uQUOTE\u       \|\u��������\u   \|\u�����\u        \|\i \i
\i \i\b\|^K?\b     Query  \|\b^KA\b ���������.  \|\b^K>\b ������\|\b`\b  Ctrl-    \|\b^[Y\b ������ \|\b^[ 0-9\b Goto  \|\i \i
\i \i\b\|^[D\b     ����   \|\b^[H\b ���������   \|          \|\b^\\\b Meta-    \|\b^[O\b ���.<  \|\b^[^[\b �������.\i \|\i
}

{Programs
\i   ���� ��������� - \|��������� �� F1    ����.����� - ^P     ����. ����� ^N      \i
\i \i\|\u��������\u             \|\u�����\u      \|\uCOMPILING\u                                    \|\i \i
\i \i\b\|^G\b  � �����. ( [ {   \|\b^K,\b �����  \|\b^[C\b Compile and parse errors                 \|\i \i
\i \i\b\|^K-\b �� ������� ����� \|\b^K.\b ������ \|\b^[E\b Parse errors                             \|\i \i
\i \i\b\|^K=\b �� ����. �����       \|       \|\b^[=\b To next error                            \|\i \i
\i \i\b\|^K;\b ����� ����� �����    \|       \|\b^[-\b To prev. error                           \|\i \i
}

{Search
\i   Help Screen    \|turn off with ^KH    prev. screen ^[,    next screen ^[.     \i
\i \iSearch sequences:                                                            \|\i \i
\i \i    \\^  \\$  matches beg./end of line       \\.     match any single char      \|\i \i
\i \i    \\<  \\>  matches beg./end of word       \\!     match char or expression   \|\i \i
\i \i    \\(  \\)  grouping                       \\|     match left or right         \|\i \i
\i \i    \\[a-z]  matches one of a set                                             \|\i \i
\i \i    \\{1,3}  match 1 - 3 occurrences        \\?     match 0 or 1 occurrence     \|\i \i
\i \i    \\+      match 1 or more occurrences    \\*     match 0 or more occurrences \|\i \i
\i \iReplace sequences:                                                           \|\i \i
\i \i    \\&      replaced with entire match     \\1 - 9 replaced with Nth group   \|\i \i
\i \i    \\u \\l   convert next to upper/lower    \\U \\L  case convert until \\E     \|\i \i
}

{Escape sequences
\i   Help Screen    \|turn off with ^KH    prev. screen ^[,    next screen ^[.     \i
\i \iEscape sequences: \\x{10fff}  Unicode code point   \\p{Ll}  Unicode category \|\i \i
\i \i    \\i / \\I  Identifier start      \\t  tab          \\e  escape               \|\i \i
\i \i    \\c / \\C  Identifier continue   \\n  newline      \\r  carriage return      \|\i \i
\i \i    \\d / \\D  Digit / Not a digit   \\b  backspace  \\xFF  hex character        \|\i \i
\i \i    \\w / \\W  Word / Not a word     \\a  alert      \\377  octal character      \|\i \i
\i \i    \\s / \\S  Space / Not a space   \\f  formfeed     \\\\  backslash            \|\i \i
}

{SearchOptions
\i   Help Screen    \|turn off with ^KH    prev. screen ^[,    next screen ^[.     \i
\i \iSearch options:                                                              \|\i \i
\i \i     r Replace      k Restrict search to highlighted block                   \|\i \i
\i \i     i Ignore case  b Search backwards instead of forwards                   \|\i \i
\i \i                    a Search across all loaded files                         \|\i \i
\i \i                    e Search across all files in Grep or Compile error list  \|\i \i
\i \i w / n  Allow / prevent wrap to start of file                                \|\i \i
\i \i x / y  Search text is standard format / JOE format regular expression       \|\i \i
\i \i   nnn  Perform exactly nnn replacements                                     \|\i \i
}

{Math
\i   Help Screen    \|turn off with ^KH    prev. screen ^[,    next screen ^[.     \i
\i \i \uCOMMANDS\u (hit ESC m for math)  \uFUNCTIONS\u                                    \|\i \i
\i \i     hex hex display mode       sin cos tab asin acos atan                   \|\i \i
\i \i     dec decimal mode           sinh cosh tanh asinh acosh atanh             \|\i \i
\i \i     ins type result into file  sqrt cbrt exp ln log                         \|\i \i
\i \i    eval evaluate block         int floor ceil abs erg ergc                  \|\i \i
\i \i    0xff enter number in hex    joe(..macro..) - runs an editor macro        \|\i \i
\i \i    3e-4 floating point decimal \uBLOCK\u                                        \|\i \i
\i \i    a=10 assign a variable      sum cnt  Sum, count                          \|\i \i
\i \i 2+3:ins multiple commands      avg dev  Average, std. deviation             \|\i \i
\i \i    e pi constants              \uOPERATORS\u                                    \|\i \i
\i \i     ans previous result        ! ^  * / %  + -  < <= > >= == !=  &&  ||  ? :\|\i \i
}

{Names
\i   ���� ��������� - \|��������� �� F1    ����.����� - ^P     ����. ����� ^N      \i
\i \i ������� TAB �� ������ ����� ����� ��� ��������� ���� ���� ������            \|\i \i
\i \i ��� ����������� ������� �����/���� ��� ������ �� ����� ����������� ����     \|\i \i
\i \i ����������� ����� ������:                                                   \|\i \i
\i \i      !command                 ����� �/�� ������� �����                      \|\i \i
\i \i      >>filename               ��������� � �����                             \|\i \i
\i \i      -                        ������/������ �/�� ������������ �����/������  \|\i \i
\i \i      filename,START,SIZE      ������/������ ����� �����/����������          \|\i \i
\i \i          ������� START/SIZE � 10-��� (255), 8-��� (0377) ��� 16-��� (0xFF)  \|\i \i
}

{Joe
\i   ���� ��������� - \|��������� �� F1    ����.����� - ^P     ����. ����� ^N      \i
\i \i Send bug reports to: http://sourceforge.net/projects/joe-editor             \|\i \i
\i \i \|\i \i
\i \i  default joerc file is here /home/olli/joe-armv5/etc/joe/joerc \|\i \i
\i \i  default syntax and i18n files are here /home/olli/joe-armv5/share/joe \|\i \i
\i \i  additional documentation can be found here /home/olli/joe-armv5/share/doc/joe \|\i \i
}

{CharTable
\i   Help Screen    \|turn off with F1     prev. screen ^P                         \i
\i \i\| Dec  \u 0123 4567  8901 2345    0123 4567  8901 2345 \u  Dec \|\i \i
\i \i\|     |                                              |     \|\i \i
\i \i\|   0 | \u@ABC\u \uDEFG\u  \uHIJK\u \uLMNO\u    \i\u@ABC\u\i \i\uDEFG\u\i  \i\uHIJK\u\i \i\uLMNO\u\i | 128 \|\i \i
\i \i\|  16 | \uPQRS\u \uTUVW\u  \uXYZ[\u \u\\]^_\u    \i\uPQRS\u\i \i\uTUVW\u\i  \i\uXYZ[\u\i \i\u\\]^_\u\i | 144 \|\i \i
\i \i\|  32 |  !"# $%&'  ()*+ ,-./    ���� ����  ���� ���� | 160 \|\i \i
\i \i\|  48 | 0123 4567  89:; <=>?    ���� ����  ���� ���� | 176 \|\i \i
\i \i\|  64 | @ABC DEFG  HIJK LMNO    ���� ����  ���� ���� | 192 \|\i \i
\i \i\|  80 | PQRS TUVW  XYZ[ \\]^_    ���� ����  ���� ���� | 208 \|\i \i
\i \i\|  96 | `abc defg  hijk lmno    ���� ����  ���� ���� | 224 \|\i \i
\i \i\| 112 | pqrs tuvw  xyz{ |}~    ���� ����  ���� ���� | 240 \|\i \i
}

 ��������� ������: ��������� ����������:

 �� ������ ������� ������ �� ���������� �������:

	:main		��� ���� ��������������
	:prompt		��� ����� ��������
	:query		For single-character query lines
	:querya		Singe-character query for quote
	:querysr	Search & Replace single-character query
	:shell		For shell windows
	:vtshell	For terminal emulator windows

 ������ ������ ����� ����� ���� ���������� ��� ��������������� ����� ���
 ��� ������������� � ������ '-keymap'.

 �����������:
 :inherit name		��� ����������� ������ name � �������
 :delete key		������� ������� �� ������� ������

 �������:

 ����������� ^@ - ^_, ^# � ^? ��� ����������� ����������� ��������
 ����������� SP ��� ����������� �������
 ����������� TO b ��� ��������� ��������� ��������
 ����������� MDOWN, MDRAG, MUP, M2DOWN, M2DRAG, M2UP, M3DOWN, M3DRAG, M3UP ��� ����
 ����������� MWDOWN, MWUP ��� ������ ����

 �� ����� ������ ������������ ����� �������� termcap.  ��������:

	.ku		������� �����
	.kd		������� ����
	.kl		������� �����
	.kr		������� ������
	.kh		Home
	.kH		End
	.kI		Insert
	.kD		Delete
	.kP		PgUp
	.kN		PgDn
	.k1 - .k9	F1 - F9
	.k0		F0 ��� F10
	.k;		F10

 �������:

 ������� ������ ����� ���� ��������� ����� ��� ����� ������� ������,
 ������������ ��������. ��������:

 eof,bol	^T Z		������� � ������ ��������� ������

 Also quoted matter is typed in literally:

 bol,">",dnarw	.k1		Quote news article line

 ������ ����� ������������ �� ��������� ������, ���� ������������� �������

 ������� ��� ����������� ������� ����� ���� ������� � ������� :def.  
 ��������, �� ������ �������:

 :def foo eof,bol

 ��� ����������� ������� foo, ������� ����� ��������� ������� 
 � ������ ��������� ������.

:windows		����� ������� ��� ���� ����
type		U+0 TO U+10FFFF
abort		^C		��������� ����������
 abort		^K Q
 abort		^K ^Q
 abort		^K q
querysave,query,killjoe	^K Q	Query to save files, then exit
querysave,query,killjoe	^K ^Q
querysave,query,killjoe	^K q
arg		^K \		������ ��������� ������� 
explode		^K I		���������� ��� ���� ��� ������ ����
explode		^K ^I
explode		^K i
help		.k1
help		.k8
help		.k9
help		.F1
help		.F4
help		.F8
help		.F9
help		.FB
help		.FC
help		^K H		���������
help		^K ^H
help		^K h
hnext		^N		��������� �������� ���������
hprev		^P  		���������� �������� ���������
math		^[ m		�����������
math		^[ M		�����������
math		^[ ^M		�����������
msg		^[ h		����� ���������
msg		^[ H		����� ���������
msg		^[ ^H		����� ���������
nextw		^K N		�� ��������� ����
nextw		^K ^N
nextw		^K n
nextw		^[ [ 1 ; 3 C	������ Alt � (�����) xterm
nextw		^[ [ 3 C	������ Alt � gnome-terminal
pgdn		.kN		�� ����� ����
pgdn		^V
 pgdn      ^# S
pgup		.kP		�� ����� �����
pgup		^U
 pgup      ^# T
play		^K 0 TO 9	��������� �����
prevw		^K P		�� ��������� ����
prevw		^K ^P
prevw		^K p
prevw		^[ [ 1 ; 3 D	����� Alt � (�����) xterm
prevw		^[ [ 3 D	����� Alt � gnome-terminal
query		^K ?		Macro query insert
record		^K [		�������� �����
retype		^R		����������� ������
rtn		^M		������� ������
shell		^K Z		����� � ����
shell		^K ^Z
shell		^K z
stop		^K ]		����� ������ �����
 ���������� �����
defmdown	MDOWN		����������� ������ � ������� ����
defmup		MUP
defmdrag	MDRAG		�������� ������������������ ��������
defm2down	M2DOWN		�������� ����� � ������� ����
defm2up		M2UP
defm2drag	M2DRAG		�������� ������������������ ����
defm3down	M3DOWN		�������� ������ � ������� ����
defm3up		M3UP
defm3drag	M3DRAG		�������� ������������������ �����
defmiddleup	MIDDLEUP
defmiddledown	MIDDLEDOWN	Insert text

xtmouse		^[ [ M		������ ��������� ������� ���� � xterm
extmouse	^[ [ <		Introduces an extended xterm mouse event (TODO: translate to Russian)

if,"char==65",then,"it's an A",else,"it's not an a",endif	^[ q

:main			���� �������������� ������
:inherit windows

 ������� �������� �������������� ������

 Ispell
:def ispellfile filt,"cat >ispell.tmp;ispell ispell.tmp </dev/tty >/dev/tty;cat ispell.tmp;/bin/rm ispell.tmp",rtn,retype
:def ispellword psh,nextword,markk,prevword,markb,filt,"cat >ispell.tmp;ispell ispell.tmp </dev/tty >/dev/tty;tr -d <ispell.tmp '\\012';/bin/rm ispell.tmp",rtn,retype,nextword

 Aspell
:def aspellfile filt,"SPLTMP=`mktemp -t joespell.XXXXXXXXXX`;cat >$SPLTMP;aspell -x -c $SPLTMP </dev/tty >/dev/tty;cat $SPLTMP;/bin/rm $SPLTMP",rtn,retype
:def aspellword psh,nextword,markk,prevword,markb,filt,"SPLTMP=`mktemp -t joespell.XXXXXXXXXX`;cat >$SPLTMP;aspell -x -c $SPLTMP </dev/tty >/dev/tty;tr -d <$SPLTMP '\\012';/bin/rm $SPLTMP",rtn,retype,nextword

aspellfile	^[ l
aspellword	^[ n

 Compile

:def compile querysave,query,scratch,"* Build Log *",rtn,bof,markb,eof," ",markk,blkdel,build

 Grep

:def grep_find scratch,"* Grep Log *",rtn,bof,markb,eof," ",markk,blkdel,grep

 Man page

:def man scratch,"* Man Page *",rtn,bof,markb,eof," ",markk,blkdel," ",ltarw,run,"man -P cat -S 2:3 "

 Shell windows
 We load the already existing Startup Log first so that Shell does not inherit the current directory.

:def shell1 scratch_push,"* Startup Log *",rtn,scratch_push,"* Shell 1 *",rtn,vtbknd!,eof
:def shell2 scratch_push,"* Startup Log *",rtn,scratch_push,"* Shell 2 *",rtn,vtbknd!,eof
:def shell3 scratch_push,"* Startup Log *",rtn,scratch_push,"* Shell 3 *",rtn,vtbknd!,eof
:def shell4 scratch_push,"* Startup Log *",rtn,scratch_push,"* Shell 4 *",rtn,vtbknd!,eof

 Macros allowed in shell window commands
:def shell_clear psh,bof,markb,eof,markk,blkdel
:def shell_parse parserr
:def shell_gparse gparse
:def shell_release release
:def shell_math maths
:def shell_typemath txt,math,"ins",rtn,rtn,txt,"\r",rtn
:def shell_rtn rtn
:def shell_edit edit
:def shell_dellin dellin
:def shell_cd cd
:def shell_pop popabort
:def shell_markb markb
:def shell_markk markk

 Split window version
 :def shell1 if,"is_shell==0",then,tw1,mfit,endif,scratch,"* Shell 1 *",rtn,vtbknd!,eof
 :def shell2 if,"is_shell==0",then,tw1,mfit,endif,scratch,"* Shell 2 *",rtn,vtbknd!,eof
 :def shell3 if,"is_shell==0",then,tw1,mfit,endif,scratch,"* Shell 3 *",rtn,vtbknd!,eof
 :def shell4 if,"is_shell==0",then,tw1,mfit,endif,scratch,"* Shell 4 *",rtn,vtbknd!,eof

paste			^[ [ 2 0 2 ~		Base64 paste (obsolete) ???
brpaste			^[ [ 2 0 0 ~		Bracketed paste
brpaste_done		^[ [ 2 0 1 ~		Bracketed paste done
rtarw,ltarw,begin_marking,rtarw,toggle_marking	^[ [ 1 ; 5 C    Mark right Xterm
rtarw,ltarw,begin_marking,rtarw,toggle_marking	^[ [ 5 C        Mark right Gnome-terminal
 rtarw,ltarw,begin_marking,rtarw,toggle_marking	^[ O C		Mark right Putty Ctrl-rtarw
rtarw,ltarw,begin_marking,rtarw,toggle_marking	^[ O c		Mark right RxVT Ctrl-rtarw
ltarw,rtarw,begin_marking,ltarw,toggle_marking	^[ [ 1 ; 5 D    Mark left
ltarw,rtarw,begin_marking,ltarw,toggle_marking	^[ [ 5 D        Mark left
 ltarw,rtarw,begin_marking,ltarw,toggle_marking	^[ O D		Mark left Putty Ctrl-ltarw
ltarw,rtarw,begin_marking,ltarw,toggle_marking	^[ O d		Mark left RxVT Ctrl-ltarw

uparw,dnarw,begin_marking,uparw,toggle_marking	^[ [ 1 ; 5 A    Mark up
uparw,dnarw,begin_marking,uparw,toggle_marking	^[ [ 5 A        Mark up
 uparw,dnarw,begin_marking,uparw,toggle_marking	^[ O A		Mark up Putty Ctrl-uparw
uparw,dnarw,begin_marking,uparw,toggle_marking	^[ O a		Mark up RxVT Ctrl-uparw

dnarw,uparw,begin_marking,dnarw,toggle_marking	^[ [ 1 ; 5 B    Mark down
dnarw,uparw,begin_marking,dnarw,toggle_marking	^[ [ 5 B        Mark down
 dnarw,uparw,begin_marking,dnarw,toggle_marking	^[ O B		Mark down Putty Ctrl-dnarw
dnarw,uparw,begin_marking,dnarw,toggle_marking	^[ O b		Mark down RxVT Ctrl-dnarw

 �������������� �������, ������� � ���������������� �� �������� 
 ������ ����������������� ���������� JOE:

delbol		^[ o		������� �� ������ ������
delbol		^[ ^O		
dnslide		^[ z		������ ���� �� ���� ������
dnslide		^[ Z		Scroll down one line
dnslide		^[ ^Z		Scroll down one line
dnslide,dnslide,dnslide,dnslide		MWDOWN
compile		^[ c		Compile
compile		^[ ^C		Compile
compile		^[ C
grep_find	^[ g		Grep
grep_find	^[ G		Grep
grep_find	^[ ^G		Grep
execmd		^[ x		��������� ������� ��� ����������
execmd		^[ X		
execmd		^[ ^X		
jump		^[ SP
finish		^[ ^I		Complete word in document
finish		^[ ^M		Complete word: used to be math
isrch		^[ s		��������������� ����� ������
isrch		^[ S		
isrch		^[ ^S		
notmod		^[ ~		Not modified
nxterr		^[ =		� ��������� ������
parserr		^[ e		��������� ������ � ������� ������
parserr		^[ E		
parserr		^[ ^E		
prverr		^[ -		� ���������� ������
rsrch		^[ r		��������������� ����� �����
rsrch		^[ R		
rsrch		^[ ^R		
run		^[ !		��������� ��������� � ����
tomarkb		^[ b		� ������ �����
tomarkb		^[ ^B		
tomarkk		^[ k		� ����� �����
tomarkk		^[ ^K		
tomarkk		^[ K		
txt		^[ i		�������� ����� � �������� ���
txt		^[ I		
upslide		^[ w		������ ����� �� ���� ������
upslide		^[ ^W		
upslide		^[ W		
upslide,upslide,upslide,upslide		MWUP
yank		^[ y		�������� �������� ������
yankpop		^[ ^Y		
yank		^[ Y		


 toggle_marking	^@		Ctrl-space block selection method
insc		^@		Ctrl-space used to insert a space

 bufed		^[ d		���� �������
 pbuf		^[ .		��������� �����
 nbuf		^[ ,		���������� �����
nbuf		^[ v		��������� �����
nbuf		^[ V		��������� �����
nbuf		^[ ^V		��������� �����
pbuf		^[ u		���������� �����
pbuf		^[ U		���������� �����
pbuf		^[ ^U		���������� �����
 query		^[ q		Quoted insert
 byte		^[ n		������� �� ����
 col		^[ c		������� � �������
 abortbuf	^[ k		Kill current buffer- don't mess with windows
 ask		^[ a		������ �� ���������� �������� ������
 bop		^[ p		�� ����� �����
 bos		^[ x		� ����� ������
 copy		^[ ^W		Copy block into yank
 dupw		^[ \		��������� ����
 eop		^[ n		������ �� �����
 format		^[ j		������������� �����, ��������� ����
 markl		^[ l		�������� ������
 nmark		^[ @		��������� �������
 pop		^[ >		�������� ���� ������
 psh		^[ <		�������� ���� 
 swap		^[ x		�������� ������� ������ ������� ����� � ������
 tomarkbk	^[ g		���������� � ������ � � ����� �����
 tos		^[ e		� ������ ������
 tw0		^[ 0		����� ������� ���� (������� �����)
 tw1		^[ 1		����� ��� ������ ���� (������� ������)
 uarg		^[ u		������������� ��������
 yank		^[ ^Y		Undelete previous text
 yapp		^[ w		Append next delete to previous yank

 ����������� ���������������� ��������� JOE

quote8		^\		������ ����������
quote		`		������ ����������� ������

backs		^?		Backspace
backs		^H
backw		^O		������� ����� �����
bknd		^K '		���� �����
blkcpy		.k5 		���������� ����
blkcpy		^K C		
blkcpy		^K ^C
blkcpy		^K c
blkdel		.f6 		������� ����
blkdel		.F6 		
blkdel		^K Y		
blkdel		^K ^Y
blkdel		^K y
blkmove		^K M		����������� ����
blkmove		.k6 		
blkmove		^K ^M
blkmove		^K m
blksave		.f5 		��������� ����
blksave		.F5 		
blksave		^K W		
blksave		^K ^W
blksave		^K w
bof		.k2		� ������ �����
bof		^K ^U
bof		^K u
 bol		.kh		� ������ ������
 bol		^A
home		.kh
home		^A
center		^K A		������������ ������
center		^K ^A
center		^K a
crawll		^K <		Pan left
crawll		^[ <		Pan left
crawlr		^K >		Pan right
crawlr		^[ >		Pan right
delch		.kD		������� ������
delch		^D
deleol		^J		������� �� ����� ������
dellin		^Y		������� ��� ������
delw		^W		������� �� ����� �����
dnarw		.kd		����
dnarw		^[ O B
dnarw		^[ [ B
edit		^K E		������������� ����
edit		^K ^E
edit		^K e
eof		.f2 		� ����� �����
eof		.F2 		
eof		^K V		
eof		^K ^V
eof		^K v
eol		.kH		� ����� ������
eol		.@7		
eol		^E
exsave		.k0 		��������� ���� � �����
exsave		.k; 		
exsave		^K X		
exsave		^K ^X
exsave		^K x
ffirst		.f7 		����� �������
ffirst		.F7 		
ffirst		^K F		
ffirst		^K ^F
ffirst		^K f
filt		^K /		����������� ����
 finish		^K ^M		Complete text under cursor
fnext		.k7     	����� ������
fnext		^L		
fmtblk		^K J		������������� ����� � �����
fmtblk		^K ^J
fmtblk		^K j
gomark		^[ 0 TO 9	������� � �����
groww		^K G		��������� ����
groww		^K ^G
groww		^K g
insc		.kI		�������� ������
 insc		^@
insf		^K R		�������� ����                
insf		^K ^R
insf		^K r
lindent		^K ,		�������� ���� �����
line		^L  		������� �� ��������� ������
line		^K L	
line		^K ^L
line		^K l
ltarw		.kl		�����
ltarw		^[ O D
ltarw		^[ [ D
macros		^[ d		�������� ������
macros		^[ ^D
markb		.k3 		������� ������ �����
markb		^K B		
markb		^K ^B
markb		^K b
markk		.f3 		������� ����� �����
markk		.F3 		
markk		^K K		
markk		^K ^K
markk		^K k
 mode		^T		���� �����
menu,"root",rtn	^T
nextpos		^K =		�� ��������� ������� � ������� �������
nextword	^X		�� ��������� �����
nextword	^[ [ 1 ; 5 C	ctrl right in (newer) xterm
nextword	^[ [ 5 C	ctrl right in gnome-terminal
open		^]		��������� ������
prevpos		^K -		�� ���������� ������� � �������
prevword	^Z		�� ���������� �����
prevword	^[ [ 1 ; 5 D	ctrl left in (newer) xterm
prevword	^[ [ 5 D	ctrl left in gnome-terminal
redo		^^		�������� ������ ���������
rindent		^K .		�������� ���� ������ 
rtarw		.kr		������
rtarw		^[ O C
rtarw		^[ [ C
run		^K !		Run a shell command
save		.f0 		��������� ����
save		.FA 		
save		^K D		
save		^K S
save		^K ^D
save		^K ^S
save		^K d
save		^K s
setmark		^[ ^[		���������� �����
shrinkw		^K T		��������� ����
shrinkw		^K ^T
shrinkw		^K t
splitw		^K O		��������� ����
splitw		^K ^O
splitw		^K o
stat		^K SP		�������� ������ 
tag		^K ;		����� ����� �����
tomatch		^G		� ������ ������
undo		^_		�������� ���������
uparw		.ku		�����
uparw		^[ O A
uparw		^[ [ A
shell1		^[ [ 1 1 ~
shell1		^[ O P
shell1		^[ [ [ A
shell1		.k1
shell2		^[ [ 1 2 ~
shell2		^[ O Q
shell2		^[ [ [ B
shell2		.k2
shell3		^[ [ 1 3 ~
shell3		^[ O R
shell3		^[ [ [ C
shell3		.k3
shell4		^[ [ 1 4 ~
shell4		^[ O S
shell4		^[ [ [ D
shell4		.k4

:prompt			���� �������
:inherit main
if,"byte>size",then,complete,complete,else,delch,endif	^D
complete	^I
dnarw,eol	.kd		Go down
dnarw,eol	^N
dnarw,eol	^[ O B
dnarw,eol	^[ [ B
 dnarw,eol	^# B
uparw,eol	.ku		Go up
 uparw,eol	^# A
uparw,eol	^P
uparw,eol	^[ O A
uparw,eol	^[ [ A

:menu			���� ������
:inherit windows
abort		^[ ^[
backsmenu	^H
bofmenu		^K U
bofmenu		^K ^U
bofmenu		^K u
bolmenu		.kh
bolmenu		^A
dnarwmenu	.kd
dnarwmenu	^N
dnarwmenu	^[ [ B
dnarwmenu	^[ O B
dnarwmenu	MWDOWN
eofmenu		^K V
eofmenu		^K ^V
eofmenu		^K v
eolmenu		.kH
eolmenu		^E
ltarwmenu	.kl
ltarwmenu	^B
ltarwmenu	^[ [ D
ltarwmenu	^[ O D
pgdnmenu	.kN		�� ����� ����
pgdnmenu	^V
pgdnmenu	^[ [ 6 ~
pgupmenu	.kP		�� ����� �����
pgupmenu	^U
pgupmenu	^[ [ 5 ~
rtarwmenu	.kr
rtarwmenu	^F
rtarwmenu	^[ [ C
rtarwmenu	^[ O C
rtn		SP
rtn		^I
rtn		^K H
rtn		^K h
rtn		^K ^H
tabmenu		^I
uparwmenu	.ku
uparwmenu	^P
uparwmenu	^[ [ A
uparwmenu	^[ O A
uparwmenu	MWUP
defm2down	M2DOWN		Hits return key

:query			Single-key query window
:inherit windows

:querya			Single-key query window for quoting
type		U+0 TO U+10FFFF

:querysr		Search & replace query window
type		U+0 TO U+10FFFF

:shell			Input to shell windows
:inherit main
""		^C		Abort
""		^D		Eof
"\t"		^I		Tab
""		^H		Backspace
"\r"		^M		Return
""		^?		Backspace

:vtshell		Input to ANSI shell windows
:inherit main
"[A"		 [ A
"[A"		.ku
"[B"		 [ B
"[B"		.kd
"[C"		 [ C
"[C"		.kr
"[D"		 [ D
"[D"		.kl
""		^A		BOL for bash
""		^C		Abort
""		^D		Eof
""		^E		EOL for bash
"\t"		^I		Tab
""		^H		Backspace
"\r"		^M		Return
""		^?		Backspace
