# Windows Edge Remover
![EdgeRemove](logo.png)

Bu script, Microsoft Edge'i Windows sistemlerinden kalıcı olarak siler ve her açılışta kontrol ederek tekrar yüklenmesini engeller.

## Nasıl Kullanılır?
1. Repoyu indirin.(EdgeSilici.ps1 dahil)
2. PowerShell'i Yönetici olarak açın.
3. `Set-ExecutionPolicy Bypass -Scope Process` komutunu çalıştırın.
4. `.\Kur.ps1` komutu ile kurulumu tamamlayın.(Kur.ps1 dosyasının olduğu path'de çalıştırınız.EdgeSilici.ps1 C:\ dizininde olursa daha iyi çalışır)

## Özellikler
- Her açılışta otomatik kontrol.
- Dosya sahipliğini otomatik alma (Takeown).
- Arka planda sessiz çalışma.

## EdgeRemover'ı Kaldırma
PowerShell(Yönetici)'e `Unregister-ScheduledTask -TaskName "EdgeKalicisiz" -Confirm:$false` yazmanız yeterlidir.

## İRM İsteği
`irm https://raw.githubusercontent.com/KodMaster31/EdgeRemove/main/Kur.ps1 | iex`
