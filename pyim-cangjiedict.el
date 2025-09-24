;;; pyim-cangjiedict.el --- Some cangjie dicts for pyim

;; * Header
;; Copyright (C) 2017 Yuanchen Xie <xieych@outlook.com>

;; Author: Yuanchen Xie <xieych@outlook.com>
;; URL: https://github.com/cor5corpii/pyim-cangjiedict
;; Version: 0.0.3
;; Package-Requires: ((pyim "3.7"))
;; Keywords: convenience, Chinese, pinyin, input-method, cangjie

;;; License:

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.

;; Commentary:
;; # pyim-cangjiedict README
;;
;; ## 簡介(Introduction)
;; pyim-cangjiedict 是 pyim 的一個倉頡輸入法詞庫。
;;
;; pyim-cangjiedict is a dict of Cangjie input scheme for [pyim](https://github.com/tumashu/pyim).
;;
;; 初版詞庫僅支持倉頡五代，故名稱爲`pyim-cangjie5dict`，後續加入了六代詞庫，更名爲`pyim-cangjiedict`。現已加入對三代的支持。
;;
;; The first version of the project only supported the Cangjie v5, so the name is `pyim-cangjie5dict`, and version 6th was subsequently added and renamed `pyim-cangjiedict`.
;;
;; 其中三代詞庫修改自 [Cangjie3-Plus](https://github.com/Arthurmcarthur/Cangjie3-Plus) 項目。
;; 五代詞庫修改自 [rime-cangjie](https://github.com/rime/rime-cangjie) 項目，源於《五倉世紀》。
;; 六代（蒼頡檢字法）詞庫修改自 [rime-cangjie6](https://github.com/rime-aca/rime-cangjie6) 項目。
;;
;; 三碼蒼頡輸入法詞庫修改自 [rime-sancang](https://github.com/lotem/rime-sancang) 項目，由雪齋、惜緣等整理的 [蒼頡六代構詞碼碼表](https://github.com/LEOYoon-Tsaw/Cangjie6) 結合其他信息推導而來。
;;
;; The cangjie3dict originated from the [Cangjie3-Plus](https://github.com/Arthurmcarthur/Cangjie3-Plus) project,
;; the cangjie5dict originated from the [rime-cangjie](https://github.com/rime/rime-cangjie) project,
;; the cangjie6dict is modified from the [rime-cangjie6](https://github.com/rime-aca/rime-cangjie6) project,
;;
;; And the sancangdict is modified from the [rime-sancang](https://github.com/lotem/rime-sancang) project.
;;
;; ## 安裝和使用(Installation)
;; 1. 配置melpa源，參考：http://melpa.org/#/getting-started
;; 2. M-x package-install RET pyim-cangjiedict RET
;; 3. 在emacs配置文件中（比如: ~/.emacs）添加如下代碼：
;;
;; ``` elisp
;; (require 'pyim-cangjiedict)
;; ;; 根據需要選擇倉頡輸入法（蒼頡檢字法）或三碼蒼頡輸入法。
;; (setq pyim-default-scheme 'cangjie)
;; (setq pyim-default-scheme 'sancang)
;; ;; 若選`cangjie'则以下命令可任選其一：
;; ;; (pyim-cangjie3dict-enable) ;; 啓用三代詞庫(Enable cangjie3)
;; ;; (pyim-cangjie5dict-enable) ;; 啓用五代詞庫(Enable cangjie5)
;; ;; (pyim-cangjie6dict-enable) ;; 啓用六代詞庫(Enable cangjie6)
;; ;; 若選`sancang'则使用命令：
;; ;; (pyim-sancangdict-enable) ;; 啓用三碼詞庫(Enable sancang)
;; ```

;;; Code:

(require 'pyim)

;; 倉頡輸入法，包括三代、五代及六代（蒼頡檢字法）。
(pyim-scheme-add
 '(cangjie
   :document "倉頡輸入法。"
   :class xingma
   :first-chars "abcdefghijklmnopqrstuvwxyz"
   :rest-chars "abcdefghijklmnopqrstuvwxyz"
   :code-prefix "cangjie/" ;倉頡輸入法詞庫中所有的 code 都以 "cangjie/" 開頭，防止詞庫衝突。
   :code-prefix-history ("@") ;倉頡輸入法詞庫曾經使用過的 code-prefix
   :code-split-length 5 ;默認將用戶輸入切成 5 個字符長的 code 列表（不計算 code-prefix）
   :code-maximum-length 5 ;倉頡詞庫中，code 的最大長度（不計算 code-prefix）
   :prefer-triggers nil))

;; 三碼蒼頡輸入法
(pyim-scheme-add
 '(sancang
   :document "三碼蒼頡輸入法。"
   :class xingma
   :first-chars "abcdefghijklmnopqrstuvwxyz"
   :rest-chars "abcdefghijklmnopqrstuvwxyz"
   :code-prefix "sancang/" ;倉頡輸入法詞庫中所有的 code 都以 "cangjie/" 開頭，防止詞庫衝突。
   :code-split-length 3 ;默認將用戶輸入切成 3 個字符長的 code 列表（不計算 code-prefix）
   :code-maximum-length 3 ;倉頡詞庫中，code 的最大長度（不計算 code-prefix）
   :prefer-triggers nil))

;;;###autoload
(defun pyim-cangjie3dict-enable ()
  "Add cangjie3 dict to pyim."
  (interactive)
  (let* ((dir (file-name-directory
               (locate-library "pyim-cangjiedict.el")))
         (file (concat dir "pyim-cangjie3dict.pyim")))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "cangjie3-elpa" :file ,file :elpa t))
        (message "pyim 沒有安裝，pyim-cangjie3dict 啓用失敗。")))))

;;;###autoload
(defun pyim-cangjie5dict-enable ()
  "Add cangjie5 dict to pyim."
  (interactive)
  (let* ((dir (file-name-directory
               (locate-library "pyim-cangjiedict.el")))
         (file (concat dir "pyim-cangjie5dict.pyim")))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "cangjie5-elpa" :file ,file :elpa t))
        (message "pyim 沒有安裝，pyim-cangjie5dict 啓用失敗。")))))

;;;###autoload
(defun pyim-cangjie6dict-enable ()
  "Add cangjie6 dict to pyim."
  (interactive)
  (let* ((dir (file-name-directory
               (locate-library "pyim-cangjiedict.el")))
         (file (concat dir "pyim-cangjie6dict.pyim")))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "cangjie6-elpa" :file ,file :elpa t))
        (message "pyim 沒有安裝，pyim-cangjie6dict 啓用失敗。")))))

;;;###autoload
(defun pyim-sancangdict-enable ()
  "Add sancang dict to pyim."
  (interactive)
  (let* ((dir (file-name-directory
               (locate-library "pyim-cangjiedict.el")))
         (file (concat dir "pyim-sancangdict.pyim")))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "sancang-elpa" :file ,file :elpa t))
        (message "pyim 沒有安裝，pyim-sancangdict 啓用失敗。")))))

;; * Footer

(provide 'pyim-cangjiedict)

;;; pyim-cangjiedict.el ends here
