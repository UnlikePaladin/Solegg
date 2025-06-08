import SwiftUI
import Foundation

class Steps: ObservableObject {
    @Published var goals: [Goal] = [
        Goal(state:false, name: "Hidrátate", content: Modal(imageName: "agua", title:"Toma agua cada 30 minutos, aunque no tengas sed", desc:"La sed aparece cuando *ya estás deshidratado*. Con el calor, el cuerpo pierde líquidos constantemente. Beber con frecuencia mantiene estables tu temperatura, presión y concentración. Evita desmayos y golpes de calor.", exp:2)),
        Goal(state:false, name: "Usa FPS", content: Modal(imageName: "FPS", title:"Usa protector solar (FPS 30 o más) antes de salir.", desc:"La radiación UV daña la piel incluso en días nublados. Un FPS 30 bloquea hasta el *97% de los rayos UVB, y su uso regular reduce significativamente el riesgo de * cáncer de piel, envejecimiento prematuro y quemaduras.*", exp:10)),
        Goal(state:false, name: "Ponte sombrero o gorra", content: Modal(imageName: "Gorra", title:"Ponte sombrero o gorra, de preferencia de ala ancha", desc:"Hasta *40% del calor corporal* se pierde por la cabeza. Cubrirla ayuda a mantener tu temperatura estable. Un sombrero de ala ancha protege también el rostro, orejas y cuello de quemaduras solares.", exp:10)),
        Goal(state:false, name: "No mascotas en auto", content: Modal(imageName: "Mascota", title:"Carga un paraguas para hacer sombra si no hay árboles", desc:"La sombra reduce la sensación térmica hasta *10 °C*. Llevar un paraguas te protege del sol cuando no hay infraestructura urbana verde. Es una solución portátil, económica y efectiva para prevenir insolación.", exp:10)),
        Goal(state:false, name: "Plantar", content: Modal(imageName: "plantar", title:"Lleva un paño mojado o toallitas húmedas para refrescarte", desc:"Aplicar frío en puntos clave como la nuca, muñecas o frente ayuda a enfriar la sangre y bajar tu temperatura interna. Es una técnica sencilla que puede prevenir el *golpe de calor*, sobre todo en lugares sin aire acondicionado.", exp:10)),
        Goal(state:false, name: "Cuida a tus mascotas", content: Modal(imageName: "exclamationmark.triangle.fill", title:"Saca a pasear a tus mascotas solo temprano o ya que baje el sol", desc:"El asfalto puede superar los *60 °C, suficiente para causar **quemaduras severas* en las patas en solo segundos. Si no puedes caminar descalzo tú, tu mascota tampoco. Elige horarios con sombra y lleva agua.", exp:10)),
    ]
    
    @Published var currentIndex: Int = 0
    @Published var activeModal = false
    
    
    var currentGoal: Goal{
        goals [currentIndex]
    }
    
    func showModal(){
        activeModal=true
    }
}

