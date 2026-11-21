# Contributing to tanuki-night

Thanks for your interest in tanuki-night! Issues and pull requests are both welcome, and you
don't need to write code to help: a good report with a GitLab screenshot is often all it takes
to fix a color.

- [Ways to contribute](#ways-to-contribute)
- [Opening an issue](#opening-an-issue)
- [Setting up](#setting-up)
- [How the code is laid out](#how-the-code-is-laid-out)
- [Fixing a token color](#fixing-a-token-color)
- [Adding plugin support](#adding-plugin-support)
- [Changing the palette or extras](#changing-the-palette-or-extras)
- [Testing](#testing)
- [Pull request titles and commit messages](#pull-request-titles-and-commit-messages)
- [Opening a pull request](#opening-a-pull-request)
- [Releasing](#releasing)

## Ways to contribute

- **Report a wrong color**: a token that GitLab colors differently
- **Report a bug**: an error, a broken option, a plugin that looks wrong
- **Request a feature**: support for a plugin, a language, a terminal, or a new option
- **Send a pull request**: fix any of the above yourself
- **Improve the docs**: typos, unclear steps, missing examples

## Opening an issue

1. **Search first.** Check [open and closed issues](https://github.com/MNnazrul/tanuki-night.nvim/issues?q=is%3Aissue)
   in case it's already reported or fixed.
2. **Update** tanuki-night to the latest version and check the problem is still there.
3. **Read the Limitations section** of the [README](README.md). Some differences from
   GitLab are known and can't be fixed in Neovim.
4. [**Open a new issue**](https://github.com/MNnazrul/tanuki-night.nvim/issues/new/choose) and pick
   a template:

| Template | Use it for |
|---|---|
| **Wrong color** | A token looks different from GitLab |
| **Bug report** | An error, an option that doesn't work, a plugin that looks wrong |
| **Feature request** | Plugin support, language rules, a terminal theme, a new option |

### What makes a good color report

GitLab is the reference, so show the same code in both places:

- A screenshot of the code in **GitLab** (file view or merge request), and whether you use its
  Dark or Light syntax theme. A link to the file and line range helps too.
- A screenshot of the same code in **Neovim** with tanuki-night or tanuki-day.
- The output of **`:Inspect`** with the cursor on the wrong token. It shows which Treesitter
  captures and highlight groups apply, which usually points straight at the fix.
- The output of **`:checkhealth tanuki-night`**. It shows your Neovim version, whether a
  **Treesitter parser** is installed for the language, and whether the queries compile.
  Without a parser Neovim falls back to Vim's regex syntax and tanuki-day's language rules
  can't apply.

### What makes a good bug report

- What happened, what you expected, and any error message.
- The output of `:checkhealth tanuki-night`.
- Steps to reproduce, starting from a minimal config. The **Bug report** template includes a
  `repro.lua` you can run with `nvim -u repro.lua`. It installs everything into `./.repro`, so
  your own config isn't touched, and it rules out conflicts with other plugins.

## Setting up

You need:

- Neovim 0.9+ (0.11+ recommended for development)
- Vim 8+ for `make test-vim`
- [StyLua](https://github.com/JohnnyMorganz/StyLua) for formatting
- Optional: Treesitter parsers for the languages you work on (`:TSInstall rust` with
  nvim-treesitter)

Fork the repository on GitHub, then clone your fork and create a branch for your change:

```sh
git clone https://github.com/<you>/tanuki-night.nvim
cd tanuki-night.nvim
git checkout -b fix-rust-attributes
```

Point your Neovim config at the clone so you see your changes while you work:

```lua
-- lazy.nvim
{
  dir = "~/code/tanuki-night.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("tanuki-night")
  end,
}
```

After an edit, run `:colorscheme tanuki-night` (or `tanuki-day`) again. The colorscheme reloads
its modules, so you don't need to restart Neovim.

Use the project's [`.editorconfig`](.editorconfig) and [`stylua.toml`](stylua.toml) so your
formatting matches.

## How the code is laid out

| Path | What it is |
|---|---|
| `lua/tanuki-night/palette.lua` | tanuki-night colors (Tomorrow Night + GitLab dark UI colors) |
| `lua/tanuki-night/palette_day.lua` | tanuki-day colors (from GitLab's light stylesheet) |
| `lua/tanuki-night/groups/editor.lua` | UI: Normal, line numbers, floats, diff, search... (both styles) |
| `lua/tanuki-night/groups/syntax.lua`, `syntax_day.lua` | legacy Vim syntax groups (`Keyword`, `String`...) |
| `lua/tanuki-night/groups/treesitter.lua`, `treesitter_day.lua` | generic Treesitter groups (`@keyword`, `@function`...) |
| `lua/tanuki-night/groups/languages.lua`, `languages_day.lua` | per-language rules (`@keyword.modifier.c`) |
| `lua/tanuki-night/groups/lsp.lua` | diagnostics and LSP semantic tokens (both styles) |
| `lua/tanuki-night/groups/plugins.lua` | plugin highlight groups (both styles) |
| `queries/<lang>/highlights.scm` | extra Treesitter captures added on top of the default queries |
| `colors/*.lua` | `:colorscheme` entry points |
| `colors/*.vim`, `extras/` | **generated**, never edit them by hand |
| `scripts/` | generators and color-checking tools |
| `tests/` | headless tests (`run.lua` for Neovim, `run.vim` for Vim) and sample files |
| `doc/tanuki-night.txt` | `:help tanuki-night` |

Both styles share `editor.lua`, `lsp.lua` and `plugins.lua`, so always use palette names there
(`c.blue`, `c.diff_add`), never hex values. If you add a palette color, add it to **both**
`palette.lua` and `palette_day.lua`.

## Fixing a token color

1. Open the file in Neovim and run `:Inspect` on the token to see which captures apply.
2. If a generic group is wrong for **every** language, fix it in `treesitter.lua` (night) or
   `treesitter_day.lua` (day).
3. If it's wrong for **one** language, add a language-specific group in `languages.lua` or
   `languages_day.lua`, e.g. `["@keyword.modifier.c"]`.
4. If no existing capture separates the token from its neighbors, add a query to
   `queries/<lang>/highlights.scm`:
   - The file must start with `;; extends`. Without it, the file **replaces** the default
     queries for that language and breaks its highlighting.
   - Use a `@tanuki.*` capture (`@tanuki.title`, `@tanuki.preproc`...) for rules only tanuki-day
     needs. tanuki-night leaves those groups undefined, so they change nothing there, and they
     don't affect other colorschemes either.
   - Add a comment saying which GitLab behavior the rule copies.
5. Check the result in **both** styles.

`scripts/inspect.lua` prints the final color of every word in a file, which makes before/after
comparisons easy:

```sh
nvim --headless -u NONE -l scripts/inspect.lua tests/samples/sample.c
```

```text
4: static=yellow  const=yellow  unsigned=yellow  int=yellow  limit=fg  0x80=orange
```

## Adding plugin support

1. **Find the plugin's highlight groups** in its README, its `:help` page, or its source (search
   for `nvim_set_hl` or `hi def link`). `:Inspect` on a plugin window also shows them.
2. **Add them to `lua/tanuki-night/groups/plugins.lua`**, grouped under a comment with the plugin
   name. Use palette names so the same code works for both styles:

   ```lua
   -- cool-finder.nvim
   CoolFinderNormal = { fg = c.fg, bg = c.bg_alt },
   CoolFinderBorder = { fg = c.border, bg = c.bg_alt },
   CoolFinderMatch = { fg = c.blue, bold = true },
   CoolFinderSelected = { bg = c.bg_hl },
   CoolFinderTitle = "Title", -- a string links to another group
   ```

   Look at plugins that are already there for the colors used for floats, borders, matches
   and selections, so your plugin fits in.
3. **Add the plugin to the Plugin support list** in `README.md`.
4. **Check it in both styles** with the plugin installed, and add screenshots to your pull
   request.

## Changing the palette or extras

The Vim colorschemes, NvChad themes and terminal themes (kitty, Ghostty, Alacritty, WezTerm)
are all generated from the palette and highlight groups. After any change:

```sh
make gen
```

Commit the regenerated files together with your change. If the change is visible in the README
palette tables, update those too. To support a new terminal, add it to `scripts/gen_extras.lua`
and to the Extras table in `README.md`.

## Testing

Run these before you open a pull request:

```sh
make gen        # regenerate colors/*.vim and extras/
make test       # Neovim tests (both styles)
make test-vim   # Vim tests for the generated colors/*.vim
make lint       # StyLua check (make fmt fixes it)
```

If you changed anything in `queries/`, also run the Treesitter query tests. They need real
parsers, so build them once first (needs git, a C compiler and the
[tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/releases)):

```sh
make parsers        # builds parsers into .tests/ts (ignored by git)
make test-queries   # every query compiles and every sample highlights without errors
```

CI runs all of these: StyLua, the Neovim tests on 0.9 (the oldest supported version), stable
and nightly, the Vim tests, and the query tests. It also **fails if generated files are out of
date**.

If you add an option or change behavior, add a test to `tests/run.lua` (and `tests/run.vim` if
it affects Vim), and update `README.md` and `doc/tanuki-night.txt`.

## Pull request titles and commit messages

Pull requests are **squash-merged**, and the pull request title becomes the commit message on
`main`. Releases are made from those messages (see [Releasing](#releasing)), so titles follow
[Conventional Commits](https://www.conventionalcommits.org/): `type(scope): subject`.

| Type | Use it for | Release |
|---|---|---|
| `fix` | a wrong color, a bug | patch (1.0.**1**) |
| `feat` | plugin support, language rules, an extra, a new option | minor (1.**1**.0) |
| `perf` | faster loading | patch |
| `docs` | README, `doc/`, CONTRIBUTING | none on its own |
| `refactor`, `style`, `test`, `ci`, `build`, `chore` | internal changes | none on its own |

- The scope is optional: usually a language, plugin or extra, like `fix(rust): ...` or
  `feat(telescope): ...`.
- Start the subject with a lowercase letter and don't end it with a period.
- A change that breaks existing configs (a removed option, a renamed palette key) gets a `!`:
  `feat!: rename bg_alt to bg_float`. That makes a major release (**2**.0.0).

Examples:

```text
fix(rust): color attributes like GitLab
feat(neogit): add highlight groups
feat(extras): add foot terminal theme
docs: explain on_highlights
```

A check on every pull request makes sure the title follows these rules. Commit messages
inside your branch don't matter, since they're squashed into one.

## Opening a pull request

1. Push your branch to your fork and [open a pull request](https://github.com/MNnazrul/tanuki-night.nvim/compare)
   against `main`. The template has a short checklist.
2. Keep each pull request to **one topic**: one language, one plugin, or one bug.
3. Link the issue it fixes with `Fixes #123` in the description.
4. For color changes, add **before/after screenshots**, plus a GitLab screenshot of the same
   code if you can.
5. Give it a [Conventional Commits title](#pull-request-titles-and-commit-messages), like
   `fix(rust): color attributes like GitLab`.

If CI fails, check the log: most failures are formatting (`make fmt`), generated files that
weren't committed (`make gen`), or a pull request title that doesn't follow the rules above.

## Releasing

*This part is for the maintainer.* Releases are automated with
[release-please](https://github.com/googleapis/release-please), the same setup tokyonight.nvim
uses:

1. After every merge to `main`, release-please opens or updates **one** pull request named
   `chore(main): release x.y.z`. It bumps the version (in
   `.release-please-manifest.json` and `require("tanuki-night").version`) and adds the merged
   `feat`/`fix` changes to `CHANGELOG.md`.
2. Nothing is released until that pull request is merged, so changes can collect in it.
3. **Merging it** creates the `vX.Y.Z` tag and a GitHub Release with the changelog as notes.

The version comes from the commit types (`fix` → patch, `feat` → minor, `!` → major). To pick
the version yourself, add a `Release-As` footer to any commit on `main`:

```text
chore: release 2.0.0

Release-As: 2.0.0
```

Users who want only released versions can pin to tags, e.g. `version = "*"` in lazy.nvim.

## License

By contributing, you agree that your work is released under the project's
[MIT License](LICENSE).
