{
  description = "SmaLLM development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      python = pkgs.python313.withPackages (ps: with ps; [
        # Jupyter
        jupyter
        jupyterlab
        ipykernel
        debugpy

        # Core scientific / data stack
        numpy
        pandas
        matplotlib
        scipy

        # LLM / NLP
        tiktoken

        # Deep learning
        torch

        # Utilities
        requests
        tqdm
        psutil

        # Testing
        pytest
      ]);
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          python
        ];

        shellHook = ''
          export PATH="${python}/bin:$PATH"
          export PYTHONPATH="${python}/${python.sitePackages}:$PYTHONPATH"

          echo ""
          echo "╭──────────────────────────────────────────────╮"
          echo "│                  SmaLLM                      │"
          echo "╰──────────────────────────────────────────────╯"
          echo ""
          echo "🐍 Python:  $(python --version)"
          echo "🔥 PyTorch: $(python -c 'import torch; print(torch.__version__)')"
          echo "🔤 tiktoken: $(python -c 'import tiktoken; print(tiktoken.__version__)')"
          echo ""
          echo "Jupyter:"
          echo "  jupyter lab"
        '';
      };
    };
}