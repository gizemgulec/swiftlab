# swiftlab

Swift projeleri için platform bağımsız, test edilebilir bir başlangıç mimarisi.

## Mimari

Kod, bağımlılıkların dış katmanlardan iç katmanlara doğru aktığı üç katmana ayrılır:

```text
Presentation  ->  Domain  <-  Data
```

- `Domain/Models`: Uygulamanın iş modelleri. UI veya veri kaynağı detaylarını bilmez.
- `Domain/Repositories`: Veri erişimi için protokoller. Use case'ler yalnızca bu soyutlamalara bağlıdır.
- `Domain/UseCases`: Tek bir iş akışını temsil eden uygulama kuralları.
- `Data/Repositories`: API, veritabanı veya bellek gibi somut veri kaynakları.
- `Presentation`: ViewModel ve UI state'i. SwiftUI/UIKit ekranları bu katmanı tüketebilir.

Örnek akış:

```text
TaskListView -> TaskListViewModel -> FetchTasksUseCase -> TaskRepository
                                                        <- InMemoryTaskRepository
```

`TaskRepository` protokolü sayesinde gerçek API veya kalıcı veritabanı daha sonra
`Data` altında eklenebilir; Presentation ve Domain katmanlarının değişmesi gerekmez.

## Çalıştırma

```bash
swift test
```

Bir Xcode projesi için `Package.swift` dosyası Xcode ile açılabilir veya paket,
uygulamanın bağımlılığı olarak eklenebilir.
