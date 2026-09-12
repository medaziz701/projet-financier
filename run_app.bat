@echo off
setlocal

set "PROJECT_DIR=%~dp0"

pushd "%PROJECT_DIR%"

if not exist ".venv\Scripts\python.exe" (
    echo [INFO] Creation de l'environnement virtuel...
    py -3 -m venv .venv
)

call ".venv\Scripts\activate.bat"

if not exist logs mkdir logs

if exist requirements.txt (
    echo [INFO] Installation des dependances depuis requirements.txt...
    pip install --upgrade pip >nul 2>&1
    pip install -r requirements.txt
)

python -c "import ttkthemes" 1>nul 2>nul
if errorlevel 1 (
    echo [INFO] Installation du paquet manquant: ttkthemes
    pip install ttkthemes
)
python -c "import matplotlib" 1>nul 2>nul
if errorlevel 1 (
    echo [INFO] Installation du paquet manquant: matplotlib
    pip install matplotlib
)
python -c "import PIL" 1>nul 2>nul
if errorlevel 1 (
    echo [INFO] Installation du paquet manquant: Pillow
    pip install Pillow
)

echo [INFO] Demarrage de l'application...
python "%PROJECT_DIR%main.py" 1> "logs/run.log" 2> "logs/error.log"
set "ERR=%ERRORLEVEL%"
if not "%ERR%"=="0" (
    echo.
    echo [ERREUR] L'application s'est arretee avec le code %ERR%.
    echo Consultez logs\error.log pour le detail. Apercu:
    echo --------------------
    type "logs/error.log"
    echo --------------------
    echo.
    pause
)

popd

endlocal
