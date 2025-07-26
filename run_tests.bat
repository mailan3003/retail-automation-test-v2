@echo off
chcp 65001 > nul
set PYTHONIOENCODING=utf-8
REM Thêm thư mục chứa invoice_dynamic_vars.py vào PYTHONPATH
robot --variable ENV:lansb --pythonpath TestData/LanTest -i laninvoices TestSpecs
pause
