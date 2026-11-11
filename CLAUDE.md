# CLAUDE.md

Instrucciones para agentes de IA que trabajan en este repo. Se carga entero en cada sesión, así que mantenelo corto: acá va lo que hace falta para orientarse y trabajar (stack, comandos, estructura, convenciones, flujo). Las decisiones, limitaciones, incidentes y correcciones, con su porqué, van en `.claude/memory/`.

## Qué es este servicio

Gema `angus-sdoc` (`Angus::SDoc`): lee las definiciones YAML de un servicio angus (o cualquier documentación con esa estructura), arma su representación en objetos y la exporta a HTML (en inglés o español) y a JSON. No se despliega; los servicios la consumen desde git.

## Stack y versiones

- Ruby `>= 2.5` (`required_ruby_version` del gemspec); `.ruby-version` en 3.4.0.
- Sin dependencias de runtime. De desarrollo: `rake`, `yard`, `rspec`, `rspec-its`, `factory_bot` (`!= 6.4.5`), `json_expressions` y `simplecov`.
- La CI prueba Ruby 2.5 a 3.4 y JRuby 9.3.14.0, 9.4.1.0 y 9.4.5.0 (`.github/workflows/config.yml`).
- Sin base de datos ni servicios externos.

## Skills a cargar

Flujo de desarrollo: lo trae el plugin `bancard-agentic-framework` (BAF). Sus skills se activan solas: al iniciar la sesión el plugin inyecta `bancard-agentic-framework:using-baf`, que le dice al agente cuándo usar cada una. Todo cambio arranca en `bancard-agentic-framework:brainstorming`; si tiene varias partes, sigue con `bancard-agentic-framework:writing-plans` (el plan lo escribe el agente `planner` y lo revisa `plan-reviewer`), `bancard-agentic-framework:using-git-worktrees`, `bancard-agentic-framework:subagent-driven-development` o `bancard-agentic-framework:executing-plans`, `bancard:code-review-pr` y `bancard-agentic-framework:finishing-a-development-branch`. Un bug o un spec rojo arranca en `bancard-agentic-framework:systematic-debugging`. Ramas con `bancard:manage-branches`, commits con `bancard:make-commit` y tests con las convenciones de `bancard:add-tests`. Specs, planes y el registro de avance quedan en `.baf/`, que se ignora solo y no se commitea.

## Comandos

| Tarea | Comando |
|---|---|
| Tests | `bundle exec rspec` |
| Tests en Docker, con un Ruby puntual | `docker build --build-arg RUBY_VERSION=3.4 -t angus-sdoc . && docker run --rm angus-sdoc bundle exec rspec` |
| Tests en JRuby (Docker) | `docker run --rm -v "$PWD":/src:ro jruby:9.4.5.0 bash -c 'cp -r /src /app && cd /app && bundle install && bundle exec rspec'` (monta el repo de solo lectura y trabaja en una copia: no deja `Gemfile.lock` ni `coverage/` en el repo) |
| Shell en Docker con `lib/` y `spec/` montados | `RUBY_VERSION=2.5 bin/run` |
| Coverage | se genera en `coverage/` (`index.html` y `coverage.json`) al correr los tests; config en `.simplecov` |
| Lint | el repo no tiene linter configurado |

- `Gemfile.lock` no se commitea y Docker lo resuelve dentro de la imagen para cada Ruby.
- El Dockerfile copia `lib/angus/sdoc/version.rb` antes de `bundle install`: el gemspec hace `require 'angus/sdoc/version'` y Bundler falla sin ese archivo.

## Estructura y dónde va cada cosa

| Qué | Dónde | Regla |
|---|---|---|
| Entrada | `lib/angus-sdoc.rb`, `lib/angus/sdoc.rb`, `lib/angus/base.rb` | `angus-sdoc.rb` solo carga `angus/sdoc`; `base.rb` requiere el resto, y lo nuevo se requiere desde ahí |
| Versión | `lib/angus/sdoc/version.rb` | `Angus::SDoc::VERSION`; el gemspec la lee de ahí |
| Lectura de YAML | `lib/angus/definitions_reader.rb` | arma el `Definitions::Service` desde `service`, `proxy_operations`, `representations`, `glossary`, `messages` y `optional` (en la raíz de la carpeta de definiciones) y desde cada `**/operations.yml` (el nombre de su carpeta es el del recurso) |
| Modelos | `lib/angus/definitions/` | una clase por elemento (service, operation, message, message_field, representation, glossary…) |
| Recorte de definiciones | `lib/angus/definitions_utils.rb` | |
| Salida | `lib/angus/sdoc/html_formatter.rb`, `json_formatter.rb` y `templates/` | `HtmlFormatter.format_service(service, language)` toma `doc.<idioma>.erb` (`en` por defecto, y existe `es`); `styles.erb` es compartido |
| Excepciones | `lib/angus/exceptions/` | |
| Specs | `spec/angus/` | espeja `lib/angus/`; factories en `spec/factories/`, definiciones de ejemplo en `spec/fixtures/`, JSON esperados en `spec/json_representations/` |
| Paquete | `angus-sdoc.gemspec` | `spec.files` es `Dir.glob('{lib}/**/*')`: solo `lib/` entra a la gema |

## Convenciones

- Sin dependencias de runtime: no agregues `add_dependency`. Lo que escribas tiene que correr en Ruby 2.5 a 3.4 y en JRuby 9.3 a 9.4; la matriz de CI lo verifica.
- Los YAML se leen con `load_yaml_file` (usa `YAML.unsafe_load_file` si existe y `YAML.load_file` en Psych 3), para que Psych 3 y 4 acepten los mismos aliases y fechas. No llames a `YAML.load_file` directo.
- Los specs dependen de `-I.` en `.rspec`: 18 `require 'spec/json_representations/...'` en 9 archivos. Si lo sacás, la suite no carga.
- Specs con FactoryBot, en orden aleatorio. En `spec_helper.rb`, `require 'fiber'` va antes de `factory_bot` (JRuby 9.4.1.0).
- SimpleCov se configura en `.simplecov` (con filtros de `/config/`, `/db/`, `/log/`, `/spec/` y `.simplecov`), que se carga con `require 'simplecov'` al principio de `spec_helper.rb`, antes de cargar la gema. No llames a `SimpleCov.minimum_coverage`: si los tests fallan por coverage, la action no publica la medición. El piso (85%) lo exige `bancardsa/coverage-action` solo con `COVERAGE_ENFORCE=true`.

## Flujo de git y CI

- Rama principal y default: `master`.
- La rama de un ticket se llama exactamente como el ticket (`QBK-123`), nace de su `feature/<X>` y se integra ahí **por PR**. Nunca se trabaja ni se integra sobre `develop` o `master`. Reglas completas en `bancard:manage-branches`.
- Commits: `[TICKET-123] - Imperative description`, en inglés (`bancard:make-commit`). Sin atribución a IA ni co-authors.
- CI: GitHub Actions (`.github/workflows/config.yml`, workflow «Gem Validations»), en cada PR y en cada push a `master`: `bundle exec rspec` en Ruby 2.5 a 3.4 y en JRuby 9.3.14.0, 9.4.1.0 y 9.4.5.0, todo sobre ubuntu-22.04; en Ruby 3.4 publica el coverage con `bancardsa/coverage-action`; el job `Run tests` agrega toda la matriz en un solo status. No construye ni publica imágenes.

## Sistemas externos

- Jira en `bancard.atlassian.net` (MCP de Atlassian del plugin `bancard`); el proyecto depende del ticket.
- Sentry: este repo no reporta a Sentry (no tiene gema `sentry-*`).
- Dynatrace: el código no tiene instrumentación OpenTelemetry.
- Despliegue: no se despliega; los servicios la consumen desde git.

## Memoria y contexto no obvio

Las decisiones, limitaciones, incidentes pasados y correcciones viven en `.claude/memory/` (índice importado abajo; en Cursor, leé `.claude/memory/MEMORY.md` a mano).

@.claude/memory/MEMORY.md

- **Leer:** antes de cambiar un área, abrí las entradas del índice que la tocan.
- **Proponer (obligatorio):** si el usuario te da una regla, una corrección o una decisión con su razón («no hagas X porque Y»), aunque venga dentro de otra pregunta, o si descubrís un hecho que no se deriva del código ni del git (una limitación, un incidente), no alcanza con «tomo nota»: al final de tu respuesta, en una sección «¿Lo guardo en la memoria del equipo?», mostrá la entrada completa propuesta y esperá el OK antes de escribirla. Nunca inventes el **Por qué**; si no lo dijeron, preguntalo. Si ya hay una entrada que lo cubre, decilo en vez de proponer otra.
- **Formato:** un archivo `<tipo>-<slug>.md` con frontmatter (`name`, `description`, `tipo`, `revisado`), el **Por qué** y el **Cómo aplicarlo**, y una línea en `MEMORY.md`.
- **Mantener:** si una entrada contradice el código actual, avisá y proponé actualizarla (con `revisado` de hoy) o borrarla.
- Lo del equipo va acá aunque tu auto-memory personal te sugiera guardarlo allá; allá va solo lo personal.

## Modelo y permisos

- Modelo default del equipo: `sonnet` (fijado en `.claude/settings.json`). Equilibrio costo/calidad para el trabajo diario. Los agentes de BAF fijan su propio modelo por rol: `haiku` para explorar y verificar, `sonnet` para implementar, revisar e investigar, `opus` para planificar y revisar planes.
- Permisos compartidos en `.claude/settings.json`: lectura de git y `gh`, `bundle exec rspec`, `bundle install`, `bundle exec rake -T` y lectura de Jira y Confluence se auto-aprueban; `git push`, `gh pr create/merge/comment/review`, `gh api` y las escrituras en Jira (crear, comentar y editar issues) piden confirmación. Tus permisos personales van en `.claude/settings.local.json` (ignorado).
- El mismo archivo habilita los plugins `bancard` y `bancard-agentic-framework` para este repo y apaga `superpowers` (`enabledPlugins`): aunque los tengas apagados en tu `~/.claude/settings.json`, acá cargan igual. Superpowers se apaga porque BAF es su versión adaptada a las convenciones del equipo y usa los mismos nombres de skills (`brainstorming`, `writing-plans`...): con los dos cargados se mezclan los flujos. En Cursor no hay `enabledPlugins`: instalá los dos plugins y desinstalá superpowers.

## Hooks activos

Los trae el plugin `bancard` y corren antes de cada comando de shell del agente, en Claude Code y en Cursor. Solo bloquean lo que el equipo nunca hace; si uno te frena algo legítimo, es un bug del hook: abrí un issue en `bancard-agent-plugins` en lugar de apagarlo. No los apagues con `"disableAllHooks": true`, que también apaga el `SessionStart` de `bancard-agentic-framework`, ni deshabilites `bancard`, que es dependencia de BAF. Necesitan `python3` donde corre el agente, y en Windows también Git Bash; sin ellos, no hacen nada.

- `commit-guard`: antes de `git commit`, bloquea mensajes con atribución a IA (`Co-Authored-By: Claude` o `Anthropic`, "Generated with Claude", 🤖), también si el mensaje llega por `-F <archivo>` o dentro del mismo comando (heredoc); un mensaje que llega por una tubería (`cat msg | git commit -F -`) no lo ve.
- `push-guard`: antes de `git push`, bloquea pushes a `develop` o `master`; pushes forzados o `--delete` sobre `develop`, `master` o `feature/*`; y `--mirror`, `--prune` y `--all`. Mira la rama del repo donde corre el push, incluido un `cd <dir>` o `-C <dir>` en el mismo comando. Para reescribir tu rama de ticket usá `--force-with-lease`; `.claude/settings.json` deniega `git push --force …` y `git push -f …` (con el flag justo después de `push`).
