<p align="center">
 <img  src="https://i.ibb.co/rcXKZ7k/logo12.jpg">
</p>
<h3 align="center">- EN PROGRESO -</h3>

------------
#### Apex - ReviewTriggerHandler
El método **bulkUpdateAverageRating** actualiza el campo Valoracion Promedio de los Service Resources relacionados a las nuevas Reviews. Objetos que no están relacionados directamente, sino que las Reviews tienen una master-detail relationship con el objeto Service Appointment. Y existe un juction object entre Services Resources y Service Appointments llamado Assigned Resource.
Dicho método es utilizado en un trigger del objeto Review para que sea ejecutado cada vez que se cree un nuevo registro. 

------------
Se utiliza un *Record-Triggered Flow* que se ejecuta cuando un nuevo Service Appointment es creado, para enviar un email con los datos del turno sincrónicamente, y en forma asincrónica ejecutar el método de Apex sendMessage.

#### Apex - WhatsappUtils

El método **sendMessage** utiliza la anotación InvocableMethod para poder ser utilizado dentro del Flow. Realiza un *POST Callout* a la Whatsapp API, con el endpoint y keys registrados en un Named Credential, con la finalidad de enviar un mensaje al asociado con los datos de su turno confirmado.
La clase *FlowInputs* tiene la finalidad de permitir pasar múltiples parámetros al método anterior.

------------

#### LWC - SOQL
##### workTypeList - workTypeCard - professionalCard - reviewCard - starsRating
El componente **workTypeList** despliega una lista con las diferentes especialidades, con la lista de profesionales para cada una de ellas y exponiendo las reseñas de los asociados.

Utilizando los métodos de la clase **ProfessionalsController** para realizar las peticiones SOQL.

El componente **starsRating** permite renderizar iconos de estrellas de acuerdo a la valoración numérica. 

