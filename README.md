# KingReceiver
- iOS 13.0 ~
- 이미지 캐싱 라이브러리 [KingFisher](https://github.com/onevcat/Kingfisher) 를 모방해 구현한 모듈입니다.
- 이미지 캐싱 및 다운샘플링 기능을 지원합니다.

## 설치
- SPM (Swift Package Manager)

```
https://github.com/trumanfromkorea/KingReceiver.git
```

## 사용법

### setImage
- `setImage` 메소드를 사용합니다.

```swift
import KingReceiver
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setImageWithURL() {
        imageView.kr.setImage(
            with: "https://someimage.url",
            placeholder: UIImage.emptyImage,
            scale: 0.5
        )
    }
    
    private func setImageWithData() {
        imageView.kr.setImage(
            with: imageData,
            to: imageView.frame.size
        )
    }
}

```

### URL 을 이용하는 경우
- `URL` 타입이 아닌 `String` 타입으로 사용합니다.
- 이미지 출력 실패 시 나타낼 `placeholder` 이미지를 지정할 수 있습니다. 
- 이미지 로딩 시 나타낼 `indicator` 를 지정할 수 있습니다.
- 캐시 종류를 선택할 수 있습니다. `.memory` `.disk` `.none` 3가지 선택지가 있습니다.
- `resizing` 파라미터로 다운샘플링 여부를 선택할 수 있습니다.
- `scale` 파라미터로 다운샘플링 정도를 설정할 수 있습니다.

```swift
func setImage(
    with absoluteURL: String,
    placeholder: UIImage? = nil,
    indicator: UIActivityIndicatorView = UIActivityIndicatorView(),
    cachePolicy: ImageCacheFactory.Policy = .memory,
    resizing: Bool = true,
    scale: CGFloat = 1
)
```

### Data 를 사용하는 경우
- 유효한 `Data` 타입을 사용합니다.
- 이미지 출력 실패 시 나타낼 `placeholder` 이미지를 지정할 수 있습니다. 
- `targetSize` 를 이용해 크기를 지정할 수 있습니다.
- `scale` 파라미터로 다운샘플링 정도를 설정할 수 있습니다.

```swift
func setImage(
    with data: Data,
    placeholder: UIImage? = nil,
    to targetSize: CGSize,
    scale: CGFloat = 1
)
```
