name: Build and Release

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - name: Setup .NET 10
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: '10.0.x'

    - name: Publish DLL
      run: dotnet publish src/kang_nangkring.csproj -c Release -o ./publish

    - name: Copy Dockerfile to Publish
      run: cp Dockerfile ./publish/

    - name: Deploy to Branch
      uses: JamesIves/github-pages-deploy-action@v4
      with:
        folder: ./publish
        branch: deploy

    - name: Update VPS via SSH
      uses: appleboy/ssh-action@v1.0.3
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        script: |
          cd ~/kang-nangkring
          git fetch origin deploy
          git reset --hard origin/deploy
          # Build ulang image di VPS
          docker build -t kang-nangkring .
          # Stop & Hapus container lama (jika ada)
          docker stop bot-nangkring || true
          docker rm bot-nangkring || true
          # Jalankan container baru
          docker run -d \
            --name bot-nangkring \
            --restart always \
            -e DiscordToken=${{ secrets.DISCORD_TOKEN }} \
            kang-nangkring