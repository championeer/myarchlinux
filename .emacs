;;--------Load Path-----------------------------
(add-to-list 'load-path "/home/qianli/.emacs.d/lisp")
(add-to-list 'load-path "/home/qianli/.emacs.d/lisp-personal")
;;------------------------------------------------
(server-start);start emacs server
(prefer-coding-system 'utf-8)
(require 'unicad);encoding
(require 'linum);add line number
(require 'redo);; add redo mode
(require 'tabbar);; add tabbar mode
;;----------------Font Setting---------------------------
;(set-default-font "DejaVu Sans Mono-10")
(set-default-font "Monaco-10")
 (set-fontset-font (frame-parameter nil 'font)
               'unicode '("Microsoft YaHei" . "unicode-bmp"))
;;----------------end of font setting-------------------

;;-------------全局的快捷键-----------------------
;;定义"C-c c"和"C-z"为按键前缀
(define-prefix-command 'ctl-cc-map)
(global-set-key (kbd "C-c c") 'ctl-cc-map)
(define-prefix-command 'ctl-z-map)
(global-set-key (kbd "C-z") 'ctl-z-map)

;(global-set-key (kbd "C-,") 'scroll-left)
;; "C-,"设为屏幕左移命令
;(global-set-key (kbd "C-.") 'scroll-right)
;; "C-."设为屏幕右移命令
(global-set-key [f1] 'info )
(global-set-key [C-f1] 'manual-entry)
(global-set-key [f2] 'undo)
(global-set-key [f3] 'redo)
(global-set-key [f4] 'kill-this-buffer)
(global-set-key [f6] 'dired-jump)
(global-set-key [f8] 'calendar)
(global-set-key [C-f8] 'list-bookmarks)
(global-set-key [f9] 'gnus)

(defun du-onekey-compile ()
"Save buffers and start compile"
(interactive)
(save-some-buffers t)
(switch-to-buffer-other-window "*compilation*")
(compile compile-command))
(global-set-key [C-f11] 'compile)
(global-set-key [f11] 'du-onekey-compile)
;; C-f5, 设置编译命令; f5, 保存所有文件然后编译当前窗口文件

(global-set-key [f12] 'gdb)
;;F6设置为在Emacs中调用gdb

(global-set-key [C-f7] 'previous-error)
(global-set-key [f7] 'next-error)

(defun open-eshell-other-buffer ()
"Open eshell in other buffer"
(interactive)
(split-window-vertically)
(eshell))
(global-set-key [(f5)] 'open-eshell-other-buffer)
(global-set-key [C-f5] 'eshell)
;;目的是开一个shell的小buffer，用于更方便地测试程序(也就是运行程序了)，我经常会用到。
;;f8就是另开一个buffer然后打开shell，C-f8则是在当前的buffer打开shell

(global-set-key (kbd "M-g") 'goto-line)
;;设置M-g为goto-line

(global-set-key (kbd "C-SPC") 'nil)
;;取消control+space键设为mark

(global-set-key (kbd "C-M-SPC") 'set-mark-command)
;;这样 我就不用按 C-@ 来 setmark 了, C-@ 很不好按。

;(global-set-key [(f3)] 'speedbar);;F3打开speedbar
;(global-set-key [f12] 'ecb-activate) ;;定义F12键为激活ecb
;(global-set-key [C-f12] 'ecb-deactivate) ;;定义Ctrl+F12为停止ecb
;(global-set-key (kbd "M-s") 'speedbar-get-focus);Alt+s让speedbar获得焦点
(global-set-key "\C-x\C-m" 'buffer-menu-other-window);; 多开一个窗口显示已打开的缓冲区列表
(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key (kbd "<end>")   'end-of-line)
(global-set-key (kbd "C-<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-<end>") 'end-of-buffer)
(global-set-key (kbd "C-c u") 'revert-buffer);刷新文件
(global-set-key [(control o)] 'other-window);; 切换窗口
;(global-set-key [(control tab)] 'tabbar-forward);; 切换tab
(global-set-key (kbd "C-<tab>") 'tabbar-forward);; 切换tab
(global-set-key (kbd "C-z k") 'browse-kill-ring);;查看前面删除的内容记录
(global-set-key (kbd "C-z l") 'lpr-buffer);;打印当前buffer
(global-set-key (kbd "C-z r") 'query-replace-regexp);;带正则表达式的搜索
;;-------------end of global key----------------------

;; 设置时间戳，标识出最后一次保存文件的时间。
(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(setq time-stamp-format "%:y-%02m-%02d %3a %02H:%02M:%02S qianli")

;; 上次离开时的全局变量记录
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

;; 把 C-x C-b 那个普通的 buffer menu 换成非常方便的 ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; 打开一些禁用的功能
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

;; Color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-gnome2)

;; Common Setting
;;设置你的书签文件，默认是~/.emacs.bmk
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk")
(ido-mode t);;ido的配置,这个可以使你在用C-x C-f打开文件的时候在后面有提示
(setq visible-bell t);;关闭出错时的提示音
(setq default-major-mode 'text-mode);一打开就起用 text 模式。
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(global-font-lock-mode t);语法高亮
(auto-image-file-mode t);打开图片显示功能
(fset 'yes-or-no-p 'y-or-n-p);以 y/n代表 yes/no
(setq column-number-mode t);显示列号
(setq line-number-mode t);显示行号
(show-paren-mode t);显示括号匹配
(setq show-paren-style 'parentheses)
(display-time-mode 1);显示时间，格式如下
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(tool-bar-mode nil);去掉工具栏
(scroll-bar-mode nil);去掉滚动条
(mouse-avoidance-mode 'animate);光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。
(setq kill-ring-max 200);设置粘贴缓冲条目数量
(setq mouse-yank-at-point t);支持中键粘贴
(transient-mark-mode t);高亮显示要拷贝的区域
(setq x-select-enable-clipboard t);支持emacs和外部程序的粘贴
(setq frame-title-format "qianli@%b");在标题栏提示你目前在什么位置
(setq default-fill-column 80);默认显示 80列就换行 
;; 让sentence-end可以识别全角的标点符号
(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)
(ansi-color-for-comint-mode-on);remove broken codes in shell
;;; This is to not display the initial message (which says to a novice
;;; user what to do first if he/she is confused).
(setq inhibit-startup-message t)
;;; Use spaces instead of tabs to indent
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list())
;;; Turn on auto-fill. 
(setq auto-fill-mode t)
(setq comment-multi-line t)
(setq fill-column 75)
(setq adaptive-fill-regexp "[ \t]+\\|[ \t]*\\([0-9]+\\.\\|\\*+\\)[ \t]*")
(setq adaptive-fill-first-line-regexp "^\\* *$")

;;; Highlight during query
(setq query-replace-highlight t)
;;; Highlight incremental search
(setq search-highlight t)
(setq scroll-margin 3 scroll-conservatively 10000);;防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动，可以很好的看到上下文

;; 按%寻找匹配的括号
(local-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
    (interactive "p")
      (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
              ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
                      (t (self-insert-command (or arg 1)))))

;;备份设置
;;emacs还有一个自动保存功能，默认在~/.emacs.d/auto-save-list里，这个非常有用，我这里没有改动，具体可以参见Sams teach yourself emacs in 24hours(我简称为sams24)
;;启用版本控制，即可以备份多次
(setq version-control t)
;;备份最原始的版本两次，记第一次编辑前的文档，和第二次编辑前的文档
(setq kept-old-versions 2)
;;备份最新的版本五次，理解同上
(setq kept-new-versions 5)
;;删掉不属于以上7中版本的版本
(setq delete-old-versions t)
;;设置备份文件的路径
(setq backup-directory-alist '(("." . "~/.emacs.tmp")))
;;备份设置方法，直接拷贝
(setq backup-by-copying t)
;(setq make-backup-files nil);设定不产生备份文件
;(setq auto-save-mode nil);自动保存模式
;(setq-default make-backup-files nil);;不生成临时文件

(setq Man-notify-method 'pushy);; 当浏览 man page 时，直接跳转到 man buffer

;;--------------------------------------------------------------------------
;;代码折叠
;(require 'hideshow)
(load-library "hideshow")
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
;(add-hook 'java-mode-hook 'hs-minor-mode)
;(add-hook 'perl-mode-hook 'hs-minor-mode)
(add-hook 'php-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
;;能把一个代码块缩起来，需要的时候再展开
;;  M-x              hs-minor-mode
;;  C-c @ ESC C-s    show all
;;  C-c @ ESC C-h    hide all
;;  C-c @ C-s        show block
;;  C-c @ C-h        hide block
;;  C-c @ C-c toggle hide/show
;;--------------------------------------------------------------------------

;; Folding-mode
(load "folding" 'nomessage 'noerror)
(folding-mode-add-find-file-hook)
(folding-add-to-marks-list 'php-mode "//{"  "//}"  nil t)
(folding-add-to-marks-list 'prolog-mode "%{{{" "%}}}" nil t)
(folding-add-to-marks-list 'html-mode "<!-- {{{ " "<!-- }}} -->" " -->" nil t)
(folding-add-to-marks-list 'LaTeX-mode "%%% {{{" "%%% }}}" nil t)
(folding-add-to-marks-list 'latex-mode "%%%% {{{" "%%%% }}}" nil t)
(folding-add-to-marks-list 'BibTeX-mode "%%% {{{" "%%% }}}" nil t)
(folding-add-to-marks-list 'lisp-mode ";;; {" ";;; }" nil t)
(folding-add-to-marks-list 'shell-script-mode "# {{{" "# }}}" nil t)
(folding-add-to-marks-list 'sh-mode "# {{{ " "# }}}" nil t)

;;自动补全括号
(setq skeleton-pair t)
(local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(local-set-key (kbd "<") 'skeleton-pair-insert-maybe)

;; Insert table
(autoload 'keisen-mode "keisen-mule" "MULE table" t)

;;自动补全功能，按M-/
(global-set-key [(meta ?/)] 'hippie-expand)
(setq hippie-expand-try-functions-list
'(try-expand-line
try-expand-line-all-buffers
try-expand-list
try-expand-list-all-buffers
try-expand-dabbrev
try-expand-dabbrev-visible
try-expand-dabbrev-all-buffers
try-expand-dabbrev-from-kill
try-complete-file-name
try-complete-file-name-partially
try-complete-lisp-symbol
try-complete-lisp-symbol-partially
try-expand-whole-kill))
;;---------------------------------------
;;临时记号，C-.做一个记号，C-,跳转
(global-set-key [(control ?\.)] 'ska-point-to-register)
(global-set-key [(control ?\,)] 'ska-jump-to-register)
(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register. 
Use ska-jump-to-register to jump back to the stored 
position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun ska-jump-to-register()
  "Switches between current cursorposition and position
that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
        (jump-to-register 8)
        (set-register 8 tmp)))
;;-------------------------------------------
;;不用标记而复制
; C-c w: for copying word
(defun copy-word (&optional arg)
    "Copy words at point into kill-ring"
    (interactive "P")
    (let ((beg (progn (if (looking-back "[a-zA-Z0-9]" 1) (backward-word 1)) (point))) 
        (end (progn (forward-word arg) (point))))
    (copy-region-as-kill beg end))
)
(global-set-key (kbd "C-c w") (quote copy-word))

; C-c l: for copying line
(defun copy-line (&optional arg)
    "Save current line into Kill-Ring without mark the line "
    (interactive "P")
    (let ((beg (line-beginning-position)) 
   	      (end (line-end-position arg)))
    (copy-region-as-kill beg end))
)
(global-set-key (kbd "C-c y") (quote copy-line))

; C-c p: for copying paragraph
(defun copy-paragraph (&optional arg)
    "Copy paragraphes at point"
    (interactive "P")
    (let ((beg (progn (backward-paragraph 1) (point))) 
          (end (progn (forward-paragraph arg) (point))))
    (copy-region-as-kill beg end))
)
(global-set-key (kbd "C-c p") (quote copy-paragraph))

; C-c s: for copying string
(defun copy-string (&optional arg)
    "Copy a sequence of string into kill-ring"
    (interactive)
    (setq onPoint (point))
    (let ( 
            ( beg  (progn (re-search-backward "[\t ]" (line-beginning-position) 3 1) 
                   (if (looking-at "[\t ]") (+ (point) 1) (point) ) )
            )
            ( end  (progn  (goto-char onPoint) (re-search-forward "[\t ]" (line-end-position) 3 1)
                   (if (looking-back "[\t ]") (- (point) 1) (point) ) )
            )
	     )
     (copy-region-as-kill beg end)
     )
)
(global-set-key (kbd "C-c s") (quote copy-string))
;;------------------------------------------------------
;aspell with emacs
(setq-default ispell-program-name "aspell")
(setq-default ispell-local-dictionary "american")
(global-set-key(kbd "") 'ispell-complete-word)
;;flyspell
(dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
      (add-hook hook (lambda () (flyspell-mode -1))))
(setq flyspell-issue-message-flag nil)

;;---------------auctex----------------------
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(setq TeX-auto-untabify t) ;; 不使用 TAB字符缩进
(setq LaTeX-document-regexp "document\\|CJK\\*?")  ;; CJK 环境中不缩进
(add-hook 'LaTeX-mode-hook 'LaTeX-install-toolbar)
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(add-hook 'LaTex-mode-hook 'turn-on-reftex)

;;设置XeLaTex为默认编译命令
(add-hook 'LaTeX-mode-hook (lambda()
     (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
     (TeX-PDF-mode t)
    (setq TeX-command-default "XeLaTeX")
    (setq TeX-save-query  nil )
    (setq TeX-show-compilation t)
))
(custom-set-variables
 '(TeX-output-view-style (quote (("^pdf$" "." "evince %o %(outpage)"))))
)                                      
;;------------tabbar-----------------------------
;(require 'tabbar)
;(setq tabbar-speedkey-use t)
;(setq tabbar-speedkey-prefix (kbd "<f1>"))
(tabbar-mode 1)

(global-set-key (kbd "M--") 'tabbar-backward-group)
(global-set-key (kbd "M-=") 'tabbar-forward-group)
(global-set-key (kbd "M-1") 'tabbar-backward)
(global-set-key (kbd "M-2") 'tabbar-forward) 
;;-----------end of tabbar-----------------------

;;-----------------dired---------------------------------
(setq dired-recursive-deletes t) ; 可以递归的删除目录
(setq dired-recursive-copies t) ; 可以递归的进行拷贝
(require 'dired-x)               ; 有些特殊的功能
(setq dired-guess-shell-alist-user
      (list
        (list "\\.chm$" "chmsee")
        (list "\\.rm$" "smplayer")
        (list "\\.rmvb$" "smplayer")
        (list "\\.avi$" "smplayer")
        (list "\\.asf$" "smplayer")
        (list "\\.wmv$" "smplayer")
        (list "\\.htm$" "w3m")
        (list "\\.html$" "w3m")
        (list "\\.mpg$" "smplayer")
        (list "\\.avi$" "smplayer")
      )
) ; 设置一些文件的默认打开方式，此功能必须在(require 'dired-x)之后

;;----------------------end of dired-------------------------------
;;LISP files to be loaded

;;--------- Load w3m browser--------------------------------
(require 'w3m-load)
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "/usr/bin/conkeror")
(setq w3m-home-page "http://bullog.cn")
(eval-after-load "w3m-search"
    '(add-to-list 'w3m-search-engine-alist
    '("wikipedia" "http://en.wikipedia.org/wiki/%s" nil)
    '("tpb" "http://thepiratebay.org/search/%s/0/99/0" nil)))
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL" t)
(global-set-key "\C-xu"
    '(lambda () (interactive)
        (let ((url (thing-at-point 'url)))
        (let ((browse-url-browser-function 'browse-url-generic))
            (progn
                (other-frame 1)
                (browse-url url))))))
(global-set-key "\C-xm" 'browse-url-at-point)

(let ((map (make-keymap)))
(suppress-keymap map)
(define-key map [backspace] 'w3m-scroll-down-or-previous-url)
(define-key map [delete] 'w3m-scroll-down-or-previous-url)
(define-key map "\C-?" 'w3m-scroll-down-or-previous-url)
(define-key map "f" 'w3m-next-anchor)
(define-key map "b" 'w3m-previous-anchor)
(define-key map "n" 'next-line)
(define-key map "p" 'previous-line)
(define-key map "\C-n" 'w3m-next-buffer)
(define-key map "\C-p" 'w3m-previous-buffer)
(define-key map "\C-t" 'w3m-copy-buffer)
(define-key map "\C-m" 'w3m-view-this-url)
(define-key map "\C-c\C-k" 'w3m-process-stop)
(define-key map [(shift return)] 'w3m-view-this-url-new-session)
(define-key map [(shift kp-enter)] 'w3m-view-this-url-new-session)
(define-key map [(button2)] 'w3m-mouse-view-this-url)
(define-key map [(shift button2)] 'w3m-mouse-view-this-url-new-session)
(define-key map " " 'scroll-up)
(define-key map "a" 'w3m-bookmark-add-current-url)
(define-key map "\M-a" 'w3m-bookmark-add-this-url)
(define-key map "+" 'w3m-antenna-add-current-url)
(define-key map "A" 'w3m-antenna)
(define-key map "c" 'w3m-print-this-url)
(define-key map "C" 'w3m-print-current-url)
(define-key map "d" 'w3m-wget)
(define-key map "D" 'w3m-download-this-url)
(define-key map "g" 'w3m-goto-url)
(define-key map "G" 'w3m-goto-url-new-session)
(define-key map "h" 'describe-mode)
(define-key map "H" 'w3m-gohome)
(define-key map "I" 'w3m-toggle-inline-images)
(define-key map "\M-i" 'w3m-save-image)
(define-key map "M" 'w3m-view-url-with-external-browser)
(define-key map "B" 'w3m-view-next-page)
(define-key map "o" 'w3m-history)
(define-key map "O" 'w3m-db-history)
(define-key map "F" 'w3m-view-next-page)
(define-key map "B" 'w3m-view-previous-page)
(define-key map "q" 'w3m-close-window)
(define-key map "Q" 'w3m-quit)
(define-key map "R" 'w3m-reload-this-page)
(define-key map "s" 'w3m-search)
(define-key map "S" (lambda ()
(interactive)
(let ((current-prefix-arg t))
(call-interactively 'w3m-search))))
(define-key map "u" 'w3m-view-parent-page)
(define-key map "v" 'w3m-bookmark-view)
(define-key map "W" 'w3m-weather)
(define-key map "=" 'w3m-view-header)
(define-key map "\\" 'w3m-view-source)
(define-key map "?" 'describe-mode)
(define-key map ">" 'w3m-scroll-left)
(define-key map "<" 'w3m-scroll-right)
(define-key map "." 'beginning-of-buffer)
(define-key map "^" 'w3m-view-parent-page)
(define-key map "]" 'w3m-next-form)
(define-key map "[" 'w3m-previous-form)
(define-key map "}" 'w3m-next-image)
(define-key map "{" 'w3m-previous-image)
(define-key map "\C-c\C-c" 'w3m-submit-form)
(setq dka-w3m-map map))
;;-------------- Load CEDET-----------------------------------
;(load-file "/usr/share/emacs/site-lisp/cedet/common/cedet.el")
;; Enabling various SEMANTIC minor modes. See semantic/INSTALL for more ideas.
;; Select one of the following:

;; * This enables the database and idle reparse engines
;;(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
;(semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as the nascent intellisense mode
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;(semantic-load-enable-guady-code-helpers)

;; * This turns on which-func support (Plus all other code helpers)
;(semantic-load-enable-excessive-code-helpers)

;; This turns on modes that aid in grammar writing and semantic tool
;; development. It does not enable any other features such as code
;; helpers above.
;(semantic-load-enable-semantic-debugging-helpers)

;(setq semantic-edits-verbose-flag nil)
;;-----------
;(global-set-key [(f4)] 'speedbar-get-focus)
;(define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)

;(autoload 'speedbar-frame-mode "speedbar" "Popup a speedbar frame" t)
;(autoload 'speedbar-get-focus "speedbar" "Jump to speedbar frame" t)
;(define-key-after (lookup-key global-map [menu-bar tools])
;[speedbar]
;'("Speedbar" .
;speedbar-frame-mode)
;[calendar])
;;----------------end of cedet--------------

;;---------------- Load ecb-----------------
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/ecb")
;(require 'ecb)
;(setq ecb-tip-of-the-day nil)
;(setq ecb-options-version "2.32")
;(setq ecb-truncate-long-names nil)
;(setq ecb-windows-height 0.25)
;(setq ecb-windows-width 0.25)
;(require 'ecb-autoloads)
;;----------------end of ecb----------------

;;-------------- Load pkgbuild-mode-------------------
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

;; Web Development Environment
;;nxml mode
(load "/usr/share/emacs/site-lisp/nxml-mode/rng-auto.el")
 (setq auto-mode-alist
         (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
           auto-mode-alist))
;; Load php-mode
(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))
(add-hook 'php-mode-user-hook 'turn-on-font-lock)

;; Load mmm-mode
;(setq load-path (cons "/usr/share/emacs/site-lisp/mmm-mode" load-path))
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-group
'php-in-html
'(
    (html-php-tagged
        :submode php-mode
        :front "<[?]php"
        :back "[?]>"
        :include-back t)))
(add-hook 'html-mode-hook '(lambda ()
(setq mmm-classes '(php-in-html))
(set-face-background
'mmm-default-submode-face "Blank")
(mmm-mode-on)))
(add-to-list 'auto-mode-alist '("\\.php[345]?\'" . html-mode))
(add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil fancy-html))

;; Load css-mode
(autoload 'css-mode "css-mode")
;(setq auto-mode-alist (cons '("\.css\'" . css-mode) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level '4)

;;--------------------end------------------------
;; Load po-mode
;(setq auto-mode-alist
;           (cons '("\\.po\\'\\|\\.po\\." . po-mode) auto-mode-alist))
;(autoload 'po-mode "po-mode" "Major mode for translators to edit PO files" t)

;;--- Load python-mode---
;(autoload 'python-mode "python-mode.el" "Python mode." t)
;(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))
;;--- Load lua-mode---
;(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
;(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
;;----------------------------------------------
;;-----------emacs wiki------------------------
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-wiki")
;(require 'emacs-wiki)
;;---------twitter---------------------------
;(load-file "/home/qianli/.emacs.d/lisp/twit.el")
;(require 'twit)
;;--------- Org-mode--------------------------
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-agenda-include-diary t);include emacs diary entries into org-mode agenda
(setq org-log-done t)
(add-hook 'org-mode-hook 'turn-on-font-lock) ; Org buffers only
;; remember with orgmode
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/remember")
(require 'remember)
(org-remember-insinuate)
(setq org-directory "~/my/org/")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cr" 'org-remember)
;; remember templates
(setq org-remember-templates
 '(("Todo" ?t "* TODO %?\n %i\n %a" "~/my/org/TODO.org" "Tasks")
   ("Journal" ?j "* %U %?\n\n %i\n %a" "~/my/org/JOURNAL.org")
   ("Idea" ?i "* %^{Title}\n %i\n %a" "~/my/org/JOURNAL.org" "New Ideas")))
;----------------------
(setq org-icalendar-include-todo t)
(setq org-agenda-files '("/home/qianli/my/plan.org"))
;;------------end of org----------------------

;;--------- Planner/Muse/Remember--------------------
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/muse")
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/planner")
;; project
;(setq planner-project "WikiPlanner")
;(setq muse-project-alist
;    '(("WikiPlanner"
;            ("~/my/plans"
;             :default "index"
;             :major-mode planner-mode
;             :visit-link planner-visit-link))))
;(require 'planner)
;; muse
;(require 'muse-mode)     ; load authoring mode

;(require 'muse-html)     ; load publishing styles I use
;(require 'muse-latex)
;(require 'muse-context)

;(require 'muse-project)  ; publish files in projects
;; automatic note-taking with planner and remember
;(require 'remember-planner)
;(setq remember-handler-functions '(remember-planner-append))
;(setq remember-annotation-functions planner-annotation-functions)

;; ERC (emacs IRC mode)
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/erc")
;(require 'erc-auto)
;(autoload 'erc-select "erc" "IRC Client." t)
;(setq erc-auto-query 'bury)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 设置日历 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;设置日历的一些颜色
(setq calendar-load-hook
'(lambda ()
(set-face-foreground 'diary-face "skyblue")
(set-face-background 'holiday-face "slate blue")
(set-face-foreground 'holiday-face "white")))

;;设置我所在地方的经纬度，calendar里有个功能是日月食的预测，和你的经纬度相联系的。
;; 让emacs能计算日出日落的时间，在 calendar 上用 S 即可看到
(setq calendar-latitude +39.54)
(setq calendar-longitude +116.28)
(setq calendar-location-name "北京")

;; 设置阴历显示，在 calendar 上用 pC 显示阴历
(setq chinese-calendar-celestial-stem
["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
(setq chinese-calendar-terrestrial-branch
["子" "丑" "寅" "卯" "辰" "巳" "戊" "未" "申" "酉" "戌" "亥"])

;; 设置 calendar 的显示
(setq calendar-remove-frame-by-deleting t)
(setq calendar-week-start-day 1) ; 设置星期一为每周的第一天
(setq mark-diary-entries-in-calendar t) ; 标记calendar上有diary的日期
(setq mark-holidays-in-calendar nil) ; 为了突出有diary的日期，calendar上不标记节日
(setq view-calendar-holidays-initially nil) ; 打开calendar的时候不显示一堆节日

;; 去掉不关心的节日，设定自己在意的节日，在 calendar 上用 h 显示节日
(setq christian-holidays nil)
(setq hebrew-holidays nil)
(setq islamic-holidays nil)
(setq solar-holidays nil)
(setq general-holidays '((holiday-fixed 1 1 "元旦")
(holiday-fixed 2 14 "情人节")
(holiday-fixed 3 14 "白色情人节")
(holiday-fixed 4 1 "愚人节")
(holiday-fixed 5 1 "劳动节")
;(holiday-float 5 0 2 "母亲节")
(holiday-fixed 6 1 "儿童节")
;(holiday-float 6 0 3 "父亲节")
(holiday-fixed 7 1 "建党节")
(holiday-fixed 8 1 "建军节")
(holiday-fixed 9 10 "教师节")
(holiday-fixed 10 1 "国庆节")
(holiday-fixed 12 25 "圣诞节")))

;;Calendar模式支持各种方式来更改当前日期
;;（这里的“前”是指还没有到来的那一天，“后”是指已经过去的日子）
;; q 退出calendar模式
;; C-f 让当前日期向前一天
;; C-b 让当前日期向后一天
;; C-n 让当前日期向前一周
;; C-p 让当前日期向后一周
;; M-} 让当前日期向前一个月
;; M-{ 让当前日期向后一个月
;; C-x ] 让当前日期向前一年
;; C-x [ 让当前日期向后一年
;; C-a 移动到当前周的第一天
;; C-e 移动到当前周的最后一天
;; M-a 移动到当前月的第一天
;; M-e 多动到当前月的最后一天
;; M-< 移动到当前年的第一天
;; M-> 移动到当前年的最后一天

;;Calendar模式支持移动多种移动到特珠日期的方式
;; g d 移动到一个特别的日期
;; o 使某个特殊的月分作为中间的月分
;; . 移动到当天的日期
;; p d 显示某一天在一年中的位置，也显示本年度还有多少天。
;; C-c C-l 刷新Calendar窗口

;; Calendar支持生成LATEX代码。
;; t m 按月生成日历
;; t M 按月生成一个美化的日历
;; t d 按当天日期生成一个当天日历
;; t w 1 在一页上生成这个周的日历
;; t w 2 在两页上生成这个周的日历
;; t w 3 生成一个ISO-SYTLE风格的当前周日历
;; t w 4 生成一个从周一开始的当前周日历
;; t y 生成当前年的日历

;;EMACS Calendar支持配置节日：
;; h 显示当前的节日
;; x 定义当天为某个节日
;; u 取消当天已被定义的节日
;; e 显示所有这前后共三个月的节日。
;; M-x holiday 在另外的窗口的显示这前后三个月的节日。


;; 另外，还有一些特殊的，有意思的命令：
;; S 显示当天的日出日落时间(是大写的S)
;; p C 显示农历可以使用
;; g C 使用农历移动日期可以使用


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 日历设置结束 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 设置日记 ;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;

(setq diary-file "~/my/diary");; 默认的日记文件
(setq diary-mail-addr "zhao.qianli@gmail.com")
(add-hook 'diary-hook 'appt-make-list)
;;当你创建了一个'~/diary'文件，你就可以使用calendar去查看里面的内容。你可以查看当天的事件，相关命令如下 ：
;; d 显示被选中的日期的所有事件
;; s 显示所有事件，包括过期的，未到期的等等

;; 创建一个事件的样例：
;; 02/11/1989
;; Bill B. visits Princeton today
;; 2pm Cognitive Studies Committee meeting
;; 2:30-5:30 Liz at Lawrenceville
;; 4:00pm Dentist appt
;; 7:30pm Dinner at George's
;; 8:00-10:00pm concert

;; 创建事件的命令：
;; i d 为当天日期添加一个事件
;; i w 为当天周创建一个周事件
;; i m 为当前月创建一个月事件
;; i y 为当前年创建一个年事件
;; i a 为当前日期创建一个周年纪念日
;; i c 创建一个循环的事件
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 设置日记结束 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;保存上次打开的文件记录，加入以上设置，然后 M-x desktop-save。以后 Emacs 启动时就会打开你上次离开时的所有 buffer.M-x desktop-clear 可以删除记住的内容 
(load "desktop") 
(desktop-load-default) 
(desktop-read)

;;;;;;;;;eshell;;;;;;;;;;;;;;;;;;;;
(require 'eshell)

(setq eshell-cp-interactive-query t
      eshell-ln-interactive-query t
      eshell-mv-interactive-query t
      eshell-rm-interactive-query t
      eshell-ls-use-in-dired t
      eshell-mv-overwrite-files nil)

;; 启动设置
(defun zjs-eshell-setup ()
  (define-key eshell-mode-map "\t" 'pcomplete-list)
  (define-key eshell-mode-map (kbd "s-a") 'eshell-maybe-bol)
  (eldoc-mode 1))
(add-hook 'eshell-mode-hook 'zjs-eshell-setup)

;; 自定义补全规则
(setq eshell-cmpl-cycle-completions nil)
(defadvice pcomplete (around avoid-remote-connections activate)
  (let ((file-name-handler-alist (copy-alist file-name-handler-alist)))
    (setq file-name-handler-alist
          (delete (rassoc 'tramp-completion-file-name-handler
                          file-name-handler-alist) file-name-handler-alist))
    ad-do-it)) 

;; 在ls命令的结果列表中，用回车键和鼠标中键访问目录和文件，来自emacs-wik，感谢ted。
(eval-after-load "em-ls"
  '(progn
     (defun ted-eshell-ls-find-file-at-point ()
       (interactive)
       (let ((fname (buffer-substring-no-properties
                     (previous-single-property-change (point) 'help-echo)
                     (next-single-property-change (point) 'help-echo))))
         ;; Remove any leading whitespace, including newline that might
         ;; be fetched by buffer-substring-no-properties
         (setq fname (replace-regexp-in-string "^[ \t\n]*" "" fname))
         ;; Same for trailing whitespace and newline
         (setq fname (replace-regexp-in-string "[ \t\n]*$" "" fname))
         (cond
          ((equal "" fname)
           (message "No file name found at point"))
          (fname
           (find-file fname)))))
     
     (defun pat-eshell-ls-find-file-at-mouse-click (event)
       "Middle click on Eshell's `ls' output to open files.
 From Patrick Anderson via the wiki."
       (interactive "e")
       (ted-eshell-ls-find-file-at-point (posn-point (event-end event))))

     (let ((map (make-sparse-keymap)))
       (define-key map (kbd "RET")      'ted-eshell-ls-find-file-at-point)
       (define-key map (kbd "<return>") 'ted-eshell-ls-find-file-at-point)
       (define-key map (kbd "<mouse-2>") 'pat-eshell-ls-find-file-at-mouse-click)
       (defvar ted-eshell-ls-keymap map))

     (defadvice eshell-ls-decorated-name (after ted-electrify-ls activate)
       "Eshell's `ls' now lets you click or RET on file names to open them."
       (add-text-properties 0 (length ad-return-value)
                            (list 'help-echo "RET, mouse-2: visit this file"
                                  'mouse-face 'highlight
                                  'keymap ted-eshell-ls-keymap)
                            ad-return-value)
       ad-return-value))) 

;; 自定义提示符
(setq zjs-emacs-name "GNU Emacs-23")
(defun zjs-eshell-prompt ()
  "An Eshell prompt looks very cool."
  (let ((user (or (getenv "USER") user-login-name "ted"))
        (wd (eshell/pwd))
        (host (car (split-string (or (getenv "HOST")
                                     system-name
                                     "unknown")
                                 "\\.")))
        (term (concat zjs-emacs-name (format " PID %d" (emacs-pid))))
        (time (let ((time-1 (downcase (format-time-string "%Y.%m.%d %A %p %l:%M:%S"))))
                (if (char-equal (aref time-1 0) ?\ )
                    (substring time-1 1)
                  time-1)))
        ;; based on `eshell-exit-success-p'
        (r (if (save-match-data
                 (string-match "#<\\(Lisp object\\|function .*\\)>"
                               (or eshell-last-command-name "")))
               (format "%s" eshell-last-command-result)
             (number-to-string eshell-last-command-status)))
        (h (number-to-string (+ 1 (ring-length eshell-history-ring))))
        (char (if (= (user-uid) 0) "#" "$")))
    (concat "\n" user
            "\n"
            "In " wd
            "\n"
            "On " host "'s " term
            "\n"
            "At " time
            "\n"
            "(h=" h ", "
            "r=" r ")"
            " " char " ")))

(setq eshell-prompt-regexp
      (mapconcat
       '(lambda (str) (concat "\\(" str "\\)"))
       '("^[^#$]* [#$] "                ; default
         "^\\(mysql\\|[ ]\\{4\\}[-\"'`]\\)> "
         "^>>> "                        ; python
         "^ftp> "
         )
       "\\|"))
(setq eshell-prompt-function 'zjs-eshell-prompt) 

;; 如果光标在提示符处，移到其到行首，否则，移到提示符处。
(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
        (beginning-of-line))))

;; 使用"emacs"命令在当前的emacs中打开文件
(defun eshell/emacs (&rest args)
  "Open a file in emacs. Some habits die hard."
  (if (null args)
      ;; If I just ran "emacs", I probably expect to be launching
      ;; Emacs, which is rather silly since I'm already in Emacs.
      ;; So just pretend to do what I ask.
      (bury-buffer)
    ;; We have to expand the file names or else naming a directory in an
    ;; argument causes later arguments to be looked for in that directory,
    ;; not the starting directory
    (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args)))))) 

;; Here's a little trick to get "ssh" in eshell to launch ssh in a new
;; screen when running under GNU screen, or a new xterm when running
;; under X. Otherwise, ssh is run in a new term buffer.
(defun eshell/ssh (&rest args)
  "Secure shell"
  (let ((cmd (eshell-flatten-and-stringify
              (cons "ssh" args)))
        (display-type (framep (selected-frame))))
    (cond
     ((and
       (eq display-type 't)
       (getenv "STY"))
      (send-string-to-terminal (format "\033]83;screen %s\007" cmd)))
     ((eq display-type 'x)
      (eshell-do-eval
       (eshell-parse-command
        (format "rxvt -e %s &" cmd)))
      nil)
     (t
      (apply 'eshell-exec-visual (cons "ssh" args))))))
;; add drupal-mode
(defun drupal-mode ()
  (interactive)
  (php-mode)
  (setq c-basic-offset 2)
  (setq indent-tabs-mode nil)
  (setq fill-column 78)
  (c-set-offset 'case-label 2)
  (c-set-offset 'arglist-close 0))

(add-to-list 'auto-mode-alist '("/drupal.*\\.\\(php\\|module\\|inc\\|test\\)$" . drupal-mode))
