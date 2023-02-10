@{
    Name  = 'devblackops'
    Types = @{
        Directories = @{
            # Default directory icon
            ''        = 'nf-oct-file_directory'
            symlink   = 'nf-oct-file_symlink_directory'
            junction  = 'nf-fa-external_link'
            WellKnown = @{
                docs                    = 'nf-oct-repo'
                documents               = 'nf-oct-repo'
                desktop                 = 'nf-mdi-desktop_classic'
                contacts                = 'nf-mdi-contacts'
                apps                    = 'nf-mdi-apps'
                applications            = 'nf-mdi-apps'
                shortcuts               = 'nf-oct-file_symlink_directory'
                links                   = 'nf-oct-file_symlink_directory'
                fonts                   = 'nf-fa-font'
                images                  = 'nf-mdi-folder_image'
                photos                  = 'nf-mdi-folder_image'
                pictures                = 'nf-mdi-folder_image'
                videos                  = 'nf-mdi-movie'
                movies                  = 'nf-mdi-movie'
                media                   = 'nf-dev-html5_multimedia'
                music                   = 'nf-mdi-library_music'
                songs                   = 'nf-mdi-library_music'
                onedrive                = 'nf-mdi-onedrive'
                downloads               = 'nf-mdi-folder_download'
                src                     = 'nf-oct-terminal'
                development             = 'nf-oct-terminal'
                projects                = 'nf-seti-project'
                bin                     = 'nf-oct-file_binary'
                tests                   = 'nf-mdi-test_tube'
                windows                 = 'nf-fa-windows'
                users                   = 'nf-fa-users'
                favorites               = 'nf-mdi-folder_star'
                '.config'               = 'nf-seti-config'
                '.cache'                = 'nf-mdi-cached'
                '.vscode'               = 'nf-custom-folder_config'
                '.vscode-insiders'      = 'nf-custom-folder_config'
                '.git'                  = 'nf-custom-folder_git'
                '.github'               = 'nf-custom-folder_github'
                'github'                = 'nf-fa-github_alt'
                'node_modules'          = 'nf-custom-folder_npm'
                '.azure'                = 'nf-mdi-azure'
                '.aws'                  = 'nf-dev-aws'
                '.kube'                 = 'nf-mdi-ship_wheel'
                '.docker'               = 'nf-dev-docker'
                'umbraco'               = 'nf-mdi-umbraco'
            }
        }

        Files       = @{
            # Default file icon
            ''        = 'nf-fa-file'
            symlink   = 'nf-oct-file_symlink_file'
            junction  = 'nf-fa-external_link'
            WellKnown               = @{
                '.gitattributes'                = 'nf-dev-git'
                '.gitconfig'                    = 'nf-dev-git'
                '.gitignore'                    = 'nf-dev-git'
                '.gitmodules'                   = 'nf-dev-git'
                '.gitkeep'                      = 'nf-dev-git'
                'git-history'                   = 'nf-dev-git'
                'LICENSE'                       = 'nf-mdi-certificate'
                'CHANGELOG.md'                  = 'nf-fae-checklist_o'
                'CHANGELOG.txt'                 = 'nf-fae-checklist_o'
                'CHANGELOG'                     = 'nf-fae-checklist_o'
                'README.md'                     = 'nf-mdi-library_books'
                'README.txt'                    = 'nf-mdi-library_books'
                'README'                        = 'nf-mdi-library_books'
                '.DS_Store'                     = 'nf-fa-file_o'
                '.tsbuildinfo'                  = 'nf-seti-json'
                '.jscsrc'                       = 'nf-seti-json'
                '.jshintrc'                     = 'nf-seti-json'
                'tsconfig.json'                 = 'nf-seti-json'
                'tslint.json'                   = 'nf-seti-json'
                'composer.lock'                 = 'nf-seti-json'
                '.jsbeautifyrc'                 = 'nf-seti-json'
                '.esformatter'                  = 'nf-seti-json'
                'cdp.pid'                       = 'nf-seti-json'
                '.htaccess'                     = 'nf-mdi-file_xml'
                '.jshintignore'                 = 'nf-fa-gear'
                '.buildignore'                  = 'nf-fa-gear'
                '.mrconfig'                     = 'nf-fa-gear'
                '.yardopts'                     = 'nf-fa-gear'
                'manifest.mf'                   = 'nf-fa-gear'
                '.clang-format'                 = 'nf-fa-gear'
                '.clang-tidy'                   = 'nf-fa-gear'
                'favicon.ico'                   = 'nf-seti-favicon'
                '.travis.yml'                   = 'nf-dev-travis'
                '.gitlab-ci.yml'                = 'nf-fa-gitlab'
                '.jenkinsfile'                  = 'nf-dev-jenkins'
                'bitbucket-pipelines.yml'       = 'nf-dev-bitbucket'
                'bitbucket-pipelines.yaml'      = 'nf-dev-bitbucket'
                '.azure-pipelines.yml'          = 'nf-mdi-azure'

                # Firebase
                'firebase.json'                 = 'nf-dev-firebase'
                '.firebaserc'                   = 'nf-dev-firebase'

                # Bower
                '.bowerrc'                      = 'nf-dev-bower'
                'bower.json'                    = 'nf-dev-bower'

                # Conduct
                'code_of_conduct.md'            = 'nf-fa-handshake_o'
                'code_of_conduct.txt'           = 'nf-fa-handshake_o'

                # Docker
                'Dockerfile'                    = 'nf-dev-docker'
                'docker-compose.yml'            = 'nf-dev-docker'
                'docker-compose.yaml'           = 'nf-dev-docker'
                'docker-compose.dev.yml'        = 'nf-dev-docker'
                'docker-compose.local.yml'      = 'nf-dev-docker'
                'docker-compose.ci.yml'         = 'nf-dev-docker'
                'docker-compose.override.yml'   = 'nf-dev-docker'
                'docker-compose.staging.yml'    = 'nf-dev-docker'
                'docker-compose.prod.yml'       = 'nf-dev-docker'
                'docker-compose.production.yml' = 'nf-dev-docker'
                'docker-compose.test.yml'       = 'nf-dev-docker'

                # Vue
                'vue.config.js'                 = 'nf-mdi-vuejs'
                'vue.config.ts'                 = 'nf-mdi-vuejs'

                # Gulp
                'gulpfile.js'                   = 'nf-dev-gulp'
                'gulpfile.ts'                   = 'nf-dev-gulp'
                'gulpfile.babel.js'             = 'nf-dev-gulp'

                # Javascript
                'gruntfile.js'                  = 'nf-seti-grunt'

                # NodeJS
                'package.json'                  = 'nf-dev-nodejs_small'
                'package-lock.json'             = 'nf-dev-nodejs_small'
                '.nvmrc'                        = 'nf-dev-nodejs_small'
                '.esmrc'                        = 'nf-dev-nodejs_small'

                # NPM
                '.nmpignore'                    = 'nf-dev-npm'
                '.npmrc'                        = 'nf-dev-npm'

                # Authors
                'authors'                       = 'nf-oct-person'
                'authors.md'                    = 'nf-oct-person'
                'authors.txt'                   = 'nf-oct-person'

                # Terraform
                '.terraform.lock.hcl'           = 'nf-fa-lock'

                # Gradle
                'gradlew'                       = 'nf-mdi-elephant'
            }

            # Archive files
            '.7z'                   = 'nf-oct-file_zip'
            '.bz'                   = 'nf-oct-file_zip'
            '.tar'                  = 'nf-oct-file_zip'
            '.zip'                  = 'nf-oct-file_zip'
            '.gz'                   = 'nf-oct-file_zip'
            '.xz'                   = 'nf-oct-file_zip'
            '.br'                   = 'nf-oct-file_zip'
            '.bzip2'                = 'nf-oct-file_zip'
            '.gzip'                 = 'nf-oct-file_zip'
            '.brotli'               = 'nf-oct-file_zip'
            '.rar'                  = 'nf-oct-file_zip'
            '.tgz'                  = 'nf-oct-file_zip'

            # Executable things
            '.bat'                  = 'nf-custom-msdos'
            '.cmd'                  = 'nf-custom-msdos'
            '.exe'                  = 'nf-mdi-application'
            '.pl'                   = 'nf-dev-perl'

            '.sh'                   = 'nf-oct-terminal'

            # App Packages
            '.msi'                  = 'nf-mdi-package_variant'
            '.msix'                 = 'nf-mdi-package_variant'
            '.msixbundle'           = 'nf-mdi-package_variant'
            '.appx'                 = 'nf-mdi-package_variant'
            '.AppxBundle'           = 'nf-mdi-package_variant'
            '.deb'                  = 'nf-mdi-package_variant'
            '.rpm'                  = 'nf-mdi-package_variant'

            # PowerShell
            '.ps1'                  = 'nf-mdi-console_line'
            '.psm1'                 = 'nf-mdi-console_line'
            '.psd1'                 = 'nf-mdi-console_line'
            '.ps1xml'               = 'nf-mdi-console_line'
            '.psc1'                 = 'nf-mdi-console_line'
            '.pssc'                 = 'nf-mdi-console_line'

            # Javascript
            '.js'                   = 'nf-dev-javascript'
            '.esx'                  = 'nf-dev-javascript'
            '.mjs'                  = 'nf-dev-javascript'

            # Java
            '.java'                 = 'nf-fae-java'
            '.jar'                  = 'nf-fae-java'

            '.gradle'               = 'nf-mdi-elephant'

            # Python
            '.py'                   = 'nf-dev-python'
            '.ipynb'                = 'nf-mdi-notebook'

            # React
            '.jsx'                  = 'nf-dev-react'
            '.tsx'                  = 'nf-dev-react'

            # Typescript
            '.ts'                   = 'nf-seti-typescript'

            # Not-executable code files
            '.dll'                  = 'nf-fa-archive'

            # Importable Data files
            '.clixml'               = 'nf-dev-code_badge'
            '.csv'                  = 'nf-mdi-file_excel'
            '.tsv'                  = 'nf-mdi-file_excel'

            # Settings
            '.ini'                  = 'nf-fa-gear'
            '.dlc'                  = 'nf-fa-gear'
            '.config'               = 'nf-fa-gear'
            '.conf'                 = 'nf-fa-gear'
            '.properties'           = 'nf-fa-gear'
            '.prop'                 = 'nf-fa-gear'
            '.settings'             = 'nf-fa-gear'
            '.option'               = 'nf-fa-gear'
            '.reg'                  = 'nf-fa-gear'
            '.props'                = 'nf-fa-gear'
            '.toml'                 = 'nf-fa-gear'
            '.prefs'                = 'nf-fa-gear'
            '.sln.dotsettings'      = 'nf-fa-gear'
            '.sln.dotsettings.user' = 'nf-fa-gear'
            '.cfg'                  = 'nf-fa-gear'

            # Source Files
            '.c'                    = 'nf-mdi-language_c'
            '.cpp'                  = 'nf-mdi-language_cpp'
            '.go'                   = 'nf-dev-go'
            '.php'                  = 'nf-dev-php'

            # Visual Studio
            '.csproj'               = 'nf-dev-visualstudio'
            '.ruleset'              = 'nf-dev-visualstudio'
            '.sln'                  = 'nf-dev-visualstudio'
            '.slnf'                 = 'nf-dev-visualstudio'
            '.suo'                  = 'nf-dev-visualstudio'
            '.vb'                   = 'nf-dev-visualstudio'
            '.vbs'                  = 'nf-dev-visualstudio'
            '.vcxitems'             = 'nf-dev-visualstudio'
            '.vcxitems.filters'     = 'nf-dev-visualstudio'
            '.vcxproj'              = 'nf-dev-visualstudio'
            '.vsxproj.filters'      = 'nf-dev-visualstudio'

            # CSharp
            '.cs'                   = 'nf-mdi-language_csharp'
            '.csx'                  = 'nf-mdi-language_csharp'

            # Haskell
            '.hs'                   = 'nf-dev-haskell'

            # XAML
            '.xaml'                 = 'nf-mdi-xaml'

            # Rust
            '.rs'                   = 'nf-dev-rust'

            # Database
            '.pdb'                  = 'nf-dev-database'
            '.sql'                  = 'nf-dev-database'
            '.pks'                  = 'nf-dev-database'
            '.pkb'                  = 'nf-dev-database'
            '.accdb'                = 'nf-dev-database'
            '.mdb'                  = 'nf-dev-database'
            '.sqlite'               = 'nf-dev-database'
            '.pgsql'                = 'nf-dev-database'
            '.postgres'             = 'nf-dev-database'
            '.psql'                 = 'nf-dev-database'

            # Source Control
            '.patch'                = 'nf-dev-git'

            # Project files
            '.user'                 = 'nf-mdi-visualstudio'
            '.code-workspace'       = 'nf-mdi-visualstudio'

            # Text data files
            '.log'                  = 'nf-fa-list'
            '.txt'                  = 'nf-mdi-file_document'

            # Subtitle files
            '.srt'                  = 'nf-mdi-file_document'
            '.lrc'                  = 'nf-mdi-file_document'
            '.ass'                  = 'nf-fa-eye'

            # HTML/css
            '.html'                 = 'nf-seti-html'
            '.htm'                  = 'nf-seti-html'
            '.xhtml'                = 'nf-seti-html'
            '.html_vm'              = 'nf-seti-html'
            '.asp'                  = 'nf-seti-html'
            '.css'                  = 'nf-dev-css3'
            '.sass'                 = 'nf-dev-sass'
            '.scss'                 = 'nf-dev-sass'
            '.less'                 = 'nf-dev-less'

            # Markdown
            '.md'                   = 'nf-dev-markdown'
            '.markdown'             = 'nf-dev-markdown'
            '.rst'                  = 'nf-dev-markdown'

            # Handlebars
            '.hbs'                  = 'nf-seti-mustache'

            # JSON
            '.json'                 = 'nf-seti-json'
            '.tsbuildinfo'          = 'nf-seti-json'

            # YAML
            '.yml'                  = 'nf-mdi-format_align_left'
            '.yaml'                 = 'nf-mdi-format_align_left'

            # LUA
            '.lua'                  = 'nf-seti-lua'

            # Clojure
            '.clj'                  = 'nf-dev-clojure'
            '.cljs'                 = 'nf-dev-clojure'
            '.cljc'                 = 'nf-dev-clojure'

            # Groovy
            '.groovy'               = 'nf-dev-groovy'

            # Vue
            '.vue'                  = 'nf-mdi-vuejs'

            # Dart
            '.dart'                 = 'nf-dev-dart'

            # Elixir
            '.ex'                   = 'nf-custom-elixir'
            '.exs'                  = 'nf-custom-elixir'
            '.eex'                  = 'nf-custom-elixir'
            '.leex'                 = 'nf-custom-elixir'

            # Erlang
            '.erl'                  = 'nf-dev-erlang'

            # Elm
            '.elm'                  = 'nf-custom-elm'

            # Applescript
            '.applescript'          = 'nf-dev-apple'

            # XML
            '.xml'                  = 'nf-mdi-file_xml'
            '.plist'                = 'nf-mdi-file_xml'
            '.xsd'                  = 'nf-mdi-file_xml'
            '.dtd'                  = 'nf-mdi-file_xml'
            '.xsl'                  = 'nf-mdi-file_xml'
            '.xslt'                 = 'nf-mdi-file_xml'
            '.resx'                 = 'nf-mdi-file_xml'
            '.iml'                  = 'nf-mdi-file_xml'
            '.xquery'               = 'nf-mdi-file_xml'
            '.tmLanguage'           = 'nf-mdi-file_xml'
            '.manifest'             = 'nf-mdi-file_xml'
            '.project'              = 'nf-mdi-file_xml'

            # Documents
            '.chm'                  = 'nf-mdi-help_box'
            '.pdf'                  = 'nf-mdi-file_pdf'

            # Excel
            '.xls'                  = 'nf-mdi-file_excel'
            '.xlsx'                 = 'nf-mdi-file_excel'

            # PowerPoint
            '.pptx'                 = 'nf-mdi-file_powerpoint'
            '.ppt'                  = 'nf-mdi-file_powerpoint'
            '.pptm'                 = 'nf-mdi-file_powerpoint'
            '.potx'                 = 'nf-mdi-file_powerpoint'
            '.potm'                 = 'nf-mdi-file_powerpoint'
            '.ppsx'                 = 'nf-mdi-file_powerpoint'
            '.ppsm'                 = 'nf-mdi-file_powerpoint'
            '.pps'                  = 'nf-mdi-file_powerpoint'
            '.ppam'                 = 'nf-mdi-file_powerpoint'
            '.ppa'                  = 'nf-mdi-file_powerpoint'

            # Word
            '.doc'                  = 'nf-mdi-file_word'
            '.docx'                 = 'nf-mdi-file_word'
            '.rtf'                  = 'nf-mdi-file_word'

            # Audio
            '.mp3'                  = 'nf-fa-file_audio_o'
            '.flac'                 = 'nf-fa-file_audio_o'
            '.m4a'                  = 'nf-fa-file_audio_o'
            '.wma'                  = 'nf-fa-file_audio_o'
            '.aiff'                 = 'nf-fa-file_audio_o'
            '.wav'                  = 'nf-fa-file_audio_o'
            '.aac'                  = 'nf-fa-file_audio_o'
            '.opus'                 = 'nf-fa-file_audio_o'

            # Images
            '.png'                  = 'nf-fa-file_image_o'
            '.jpeg'                 = 'nf-fa-file_image_o'
            '.jpg'                  = 'nf-fa-file_image_o'
            '.gif'                  = 'nf-fa-file_image_o'
            '.ico'                  = 'nf-fa-file_image_o'
            '.tif'                  = 'nf-fa-file_image_o'
            '.tiff'                 = 'nf-fa-file_image_o'
            '.psd'                  = 'nf-fa-file_image_o'
            '.psb'                  = 'nf-fa-file_image_o'
            '.ami'                  = 'nf-fa-file_image_o'
            '.apx'                  = 'nf-fa-file_image_o'
            '.bmp'                  = 'nf-fa-file_image_o'
            '.bpg'                  = 'nf-fa-file_image_o'
            '.brk'                  = 'nf-fa-file_image_o'
            '.cur'                  = 'nf-fa-file_image_o'
            '.dds'                  = 'nf-fa-file_image_o'
            '.dng'                  = 'nf-fa-file_image_o'
            '.eps'                  = 'nf-fa-file_image_o'
            '.exr'                  = 'nf-fa-file_image_o'
            '.fpx'                  = 'nf-fa-file_image_o'
            '.gbr'                  = 'nf-fa-file_image_o'
            '.jbig2'                = 'nf-fa-file_image_o'
            '.jb2'                  = 'nf-fa-file_image_o'
            '.jng'                  = 'nf-fa-file_image_o'
            '.jxr'                  = 'nf-fa-file_image_o'
            '.pbm'                  = 'nf-fa-file_image_o'
            '.pgf'                  = 'nf-fa-file_image_o'
            '.pic'                  = 'nf-fa-file_image_o'
            '.raw'                  = 'nf-fa-file_image_o'
            '.webp'                 = 'nf-fa-file_image_o'
            '.svg'                  = 'nf-mdi-svg'

            # Video
            '.webm'                 = 'nf-fa-file_video_o'
            '.mkv'                  = 'nf-fa-file_video_o'
            '.flv'                  = 'nf-fa-file_video_o'
            '.vob'                  = 'nf-fa-file_video_o'
            '.ogv'                  = 'nf-fa-file_video_o'
            '.ogg'                  = 'nf-fa-file_video_o'
            '.gifv'                 = 'nf-fa-file_video_o'
            '.avi'                  = 'nf-fa-file_video_o'
            '.mov'                  = 'nf-fa-file_video_o'
            '.qt'                   = 'nf-fa-file_video_o'
            '.wmv'                  = 'nf-fa-file_video_o'
            '.yuv'                  = 'nf-fa-file_video_o'
            '.rm'                   = 'nf-fa-file_video_o'
            '.rmvb'                 = 'nf-fa-file_video_o'
            '.mp4'                  = 'nf-fa-file_video_o'
            '.mpg'                  = 'nf-fa-file_video_o'
            '.mp2'                  = 'nf-fa-file_video_o'
            '.mpeg'                 = 'nf-fa-file_video_o'
            '.mpe'                  = 'nf-fa-file_video_o'
            '.mpv'                  = 'nf-fa-file_video_o'
            '.m2v'                  = 'nf-fa-file_video_o'

            # Email
            '.ics'                  = 'nf-fa-calendar'

            # Certificates
            '.cer'                  = 'nf-fa-certificate'
            '.cert'                 = 'nf-fa-certificate'
            '.crt'                  = 'nf-fa-certificate'
            '.pfx'                  = 'nf-fa-certificate'

            # Keys
            '.pem'                  = 'nf-fa-key'
            '.pub'                  = 'nf-fa-key'
            '.key'                  = 'nf-fa-key'
            '.asc'                  = 'nf-fa-key'
            '.gpg'                  = 'nf-fa-key'

            # Fonts
            '.woff'                 = 'nf-fa-font'
            '.woff2'                = 'nf-fa-font'
            '.ttf'                  = 'nf-fa-font'
            '.eot'                  = 'nf-fa-font'
            '.suit'                 = 'nf-fa-font'
            '.otf'                  = 'nf-fa-font'
            '.bmap'                 = 'nf-fa-font'
            '.fnt'                  = 'nf-fa-font'
            '.odttf'                = 'nf-fa-font'
            '.ttc'                  = 'nf-fa-font'
            '.font'                 = 'nf-fa-font'
            '.fonts'                = 'nf-fa-font'
            '.sui'                  = 'nf-fa-font'
            '.ntf'                  = 'nf-fa-font'
            '.mrg'                  = 'nf-fa-font'

            # Ruby
            '.rb'                   = 'nf-oct-ruby'
            '.erb'                  = 'nf-oct-ruby'
            '.gemfile'              = 'nf-oct-ruby'
            'rakefile'              = 'nf-oct-ruby'

            # FSharp
            '.fs'                   = 'nf-dev-fsharp'
            '.fsx'                  = 'nf-dev-fsharp'
            '.fsi'                  = 'nf-dev-fsharp'
            '.fsproj'               = 'nf-dev-fsharp'

            # Docker
            '.dockerignore'         = 'nf-dev-docker'
            '.dockerfile'           = 'nf-dev-docker'

            # VSCode
            '.vscodeignore'         = 'nf-fa-gear'
            '.vsixmanifest'         = 'nf-fa-gear'
            '.vsix'                 = 'nf-fa-gear'
            '.code-workplace'       = 'nf-fa-gear'

            # Sublime
            '.sublime-project'      = 'nf-dev-sublime'
            '.sublime-workspace'    = 'nf-dev-sublime'

            '.lock'                 = 'nf-fa-lock'

            # Terraform
            '.tf'                   = 'nf-dev-code_badge'
            '.tfvars'               = 'nf-dev-code_badge'
            '.tf.json'              = 'nf-dev-code_badge'
            '.tfvars.json'          = 'nf-dev-code_badge'
            '.auto.tfvars'          = 'nf-dev-code_badge'
            '.auto.tfvars.json'     = 'nf-dev-code_badge'

            # Disk Image
            '.vmdk'                 = 'nf-mdi-harddisk'
            '.vhd'                  = 'nf-mdi-harddisk'
            '.vhdx'                 = 'nf-mdi-harddisk'
            '.img'                  = 'nf-fae-disco'
            '.iso'                  = 'nf-fae-disco'

            # R language
            '.R'                    = 'nf-mdi-language_r'
            '.Rmd'                  = 'nf-mdi-language_r'
            '.Rproj'                = 'nf-mdi-language_r'

            # Julia language
            '.jl'                   = 'nf-seti-julia'

            # Vim
            '.vim'                  = 'nf-custom-vim'
        }
    }
}
