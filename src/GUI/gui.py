import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle


def start_display(fileHandler, tagHandler, wallpaperHandler):
    QQuickStyle.setStyle("Fusion")

    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.addImportPath(sys.path[0])

    engine.rootContext().setContextProperty("fileHandler", fileHandler)
    engine.rootContext().setContextProperty("tagHandler", tagHandler)
    engine.rootContext().setContextProperty("wallpaperHandler", wallpaperHandler)

    qml_file = Path(__file__).parent / "pages" / "main.qml"
    engine.load(str(qml_file))

    if not engine.rootObjects():
        sys.exit(-1)

    exit_code = app.exec()
    del engine
    fileHandler.save_tag_json(tagHandler.tag_dictionary)
    sys.exit(exit_code)