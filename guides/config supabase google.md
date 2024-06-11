# Guía completa para obtener la huella digital SHA-1 y crear el ID de cliente de OAuth de Google para tu aplicación flutter 

https://www.youtube.com/watch?v=utMg6fVmX0U

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# Google Sign-In de Supabae en Flutter(android/web)

1. proyecto de flutter creado
2. instalar google-sign-in (pub.dev/packages/google_sign_in)
   1. flutter pub add google_sign_in
3. go to https://console.cloud.google.com/apis/credentials
   1. create credentials for chrome
   2. create credentials for android

      * get the package name from "build.gradle" from your project
      * get SHA-1 with "keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android" in terminal
   3. create credentials for ios

      * get the package id
      * 
      * 

ANDROID config [console cloud google] para android
--------------------------------------------------

- conseguir nombre del paquete

  - opciones:
    - androidmanifest.xml
    - build.gradle
      - sera algo similar a com.example.gestor
- Generar el APK de debug:

  - flutter build apk --debug
    - el archivo generado es: app-debug.apk y su ruta
      - ejemplo: build/app/outputs/flutter-apk
- Extraer huella sha-1 de la aplicación:

  - "ir a ruta donde esta el apk"
    - ~/.android
  - comando para obtener la key:
    - keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android
    - copiar el sha1

# generate web build

flutter build web

# configurando coneccion en la web supabase + google cloud console

ingresar a google cloud console

- copiar id cliente de web y pegarlo dentro del provider supabase
- copiar secreto del cliente web y pegarlo dentro del provider supabase

ingresar al provider supabase

- copiar callback url que me da provider supabase y pegarlo en "URI de redireccionamiento autorizados" de google cloud
  - https://samvrmunxovxptwwmplv.supabase.co/auth/v1/callback

# final config

- recuerda ir a config URL CONFIGURATION
  - https://supabase.com/dashboard/project/samvrmunxovxptwwmplv/auth/url-configuration
  - puede cambiar para prod y para dev como usar localhost o una url vercel
