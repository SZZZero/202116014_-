202116014_이서영_기말과제    

# 구현 목표

강의 시간 때 배운 맵 뷰를 이용해 자신의 위치와 이동한 위치를 이어 이동 경로를 표시한다.

### Map view
맵 뷰를 이용해 위도와 경도 그리고 범위를 성정하여 지도에 나타내고, 특정 위치를 표시하고 사용자의 터치를 인식하여 확대, 축소 및 이동 기능도 제공합니다

## 기말 과제 코드

```
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
```
맵 뷰에 대한 아웃렛 변수를 추가합니다
설정 창에서 타입을 MKMapViewe로 설정하였으니 MapKit을 import 해줍니다.


```
    let locationmanager = CLLocationManager()
    var previousCoordinate: CLLocationCoordinate2D? 
```    
이동 기록을 그려내기 위해서 이전 위치를 저장하기 위한 코드를 위해 필요한 변수를 선언합니다


```
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        myMap.showsUserLocation = true
    
        getLocationUsagePermission()
    }
```
위치 정보를 위한 각 소스들을 입력합니다.    
 ***.desiredAccuracy = kCLLocationAccuracyBest***  정확도를 최고로 설정합니다.     
 ***.requestWhenInUseAuthorization()***  위치 데이터를 추적하기 위해 사용자에게 승인을 요구합니다.    
 ***.startUpdatingLocation()***  위치 업데이트를 위한 코드입니다.      
 ***myMap.showsUserLocation = true***  위치 보기 값을 true로 설정합니다.      
 
 
```
    func getLocationUsagePermission(){
         locationmanager.requestWhenInUseAuthorization()
        }
```
GPS 허가를 받기 위한 코드입니다

```
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
                
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                DispatchQueue.main.async{
                    self.getLocationUsagePermission()
                }
                
            case .denied:
                print("GPS 권한 요청 거부됨")
                DispatchQueue.main.async {
                    self.getLocationUsagePermission()
                }
                
            default:
                print("GPS: Default")
            }
        }
```
GPS 권한 설정 여부에 따라 코드가 실행되게 구현합니다.

```
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last
                
        else {return}
        
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        if let previousCoordinate = self.previousCoordinate {
            
        var points: [CLLocationCoordinate2D] = []
            
        let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
        let point2: CLLocationCoordinate2D
        = CLLocationCoordinate2DMake(latitude, longtitude)
            
        points.append(point1)
        points.append(point2)
            
        let lineDraw = MKPolyline(coordinates: points, count:points.count)
        self.myMap.addOverlay(lineDraw)
            
        }

        self.previousCoordinate = location.coordinate
    } 
``` 
위치가 업데이트 될 때 이전 위치를 기억해뒀다가 다음 위치와의 거리 선으로 이어 그리게 됩니다.       
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  전 위치를 기억하기 위한 코드입니다.


```
   let renderer = MKPolylineRenderer(polyline: polyLine)
   renderer.strokeColor = .green
   renderer.lineWidth = 5.0
```
선의 색과 굵기를 조정할 수 있는 코드입니다.
