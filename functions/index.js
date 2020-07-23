const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()
exports.sendNotificationVer1 = functions.firestore
  .document('Messages/{groupId1}/{groupId2}/{messages}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')
    const doc = snap.data()
    console.log(doc)
    const email = doc.email
    const contentMessage = doc.messenges
    const type = doc.type
    const document_id_owner_group = doc.document_id_owner_group
    var list_document_id_ = []
   if(type == 0)
   {
    admin.firestore().collection('GroupPermission').where('list_permission', 'array-contains', 'support_chat_with_user').get().then(querySnapshotGroupPermission=>{
         querySnapshotGroupPermission.forEach(GroupPermission => {

         console.log(GroupPermission.id, '=>', GroupPermission.data());
                  const document_id_group = GroupPermission.id
                  admin.firestore().collection('DataCustommerSystem').where('list_id_group_permission', 'array-contains', document_id_group).get().then(querySnapshotDataCustommerSystem =>{
                       querySnapshotDataCustommerSystem.forEach(DataCustommerSystem=>{
                        console.log(DataCustommerSystem.id, '=>', DataCustommerSystem.data());
                         const document_id_custommer = DataCustommerSystem.data().document_id_custommer
                        if(list_document_id_.indexOf(document_id_custommer) == -1)
                        {
                            var newLength =list_document_id_.push(document_id_custommer);
                             admin.firestore().collection('CustomerProfile').doc(document_id_custommer).get()
                                                                        .then(CustommerProfileTo => {
                                                                            console.log(`Found user to: ${CustommerProfileTo.data().user_name}`)
                                                                            if (CustommerProfileTo.data().tokenFirebaseMessaging && CustommerProfileTo.data().chatting_with !== email) {//
                                                                              // Get info user from (sent)
                                                                              admin
                                                                                .firestore()
                                                                                .collection('CustomerProfile')
                                                                                .where('email', '==', email)//
                                                                                .get()
                                                                                .then(querySnapshot2 => {
                                                                                  querySnapshot2.forEach(CustommerProfileFrom => {
                                                                                    console.log(`Found user from: ${CustommerProfileFrom.data().user_name}`)
                                                                                    const payload = {
                                                                                      notification: {
                                                                                        title: `Bạn nhận được tin nhắn từ: "${CustommerProfileFrom.data().user_name}"`,
                                                                                        body: contentMessage,
                                                                                        badge: '1',
                                                                                        sound: 'default'
                                                                                      }
                                                                                    }

                                                                                    // Let push to the target device
                                                                                    admin
                                                                                      .messaging()
                                                                                      .sendToDevice(CustommerProfileTo.data().tokenFirebaseMessaging, payload)
                                                                                      .then(response => {
                                                                                        console.log('Successfully sent message:', response)
                                                                                      })
                                                                                      .catch(error => {
                                                                                        console.log('Error sending message:', error)
                                                                                      })
                                                                                  })
                                                                                })
                                                                            } else {
                                                                              console.log('Can not find tokenFirebaseMessaging target user')
                                                                            }

                                                                        })
                        }

                                          return null
                       })
                  })
                 })

         }
       )
   }
   else{
   admin.firestore()
         .collection('CustomerProfile').doc(document_id_owner_group)
         .get()
         .then(CustommerProfileTo => {
             console.log(`Found user to: ${CustommerProfileTo.data().user_name}`)
             if (CustommerProfileTo.data().tokenFirebaseMessaging && CustommerProfileTo.data().chatting_with !== email) {//
               // Get info user from (sent)
               admin
                 .firestore()
                 .collection('CustomerProfile')
                 .where('email', '==', email)//
                 .get()
                 .then(querySnapshot2 => {
                   querySnapshot2.forEach(CustommerProfileFrom => {
                     console.log(`Found user from: ${CustommerProfileFrom.data().user_name}`)
                     const payload = {
                       notification: {
                         title: `Bạn nhận được tin nhắn từ: ${CustommerProfileFrom.data().user_name}`,
                         body: contentMessage,
                         badge: '1',
                         sound: 'default'
                       }
                     }
                     // Let push to the target device
                     admin
                       .messaging()
                       .sendToDevice(CustommerProfileTo.data().tokenFirebaseMessaging, payload)
                       .then(response => {
                         console.log('Successfully sent message:', response)
                       })
                       .catch(error => {
                         console.log('Error sending message:', error)
                       })
                   })
                 })
             } else {
               console.log('Can not find tokenFirebaseMessaging target user')
             }
         })
       return null
   }
  })
exports.sendNotification = functions.firestore
  .document('Messages/{groupId1}/{groupId2}/{messages}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const email = doc.email//
    //const typeTo = doc.typeTo//
    const contentMessage = doc.messenges

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('CustomerProfile')
      .where('type', '==', 1)//
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(CustommerProfileTo => {
          console.log(`Found user to: ${CustommerProfileTo.data().user_name}`)
          if (CustommerProfileTo.data().tokenFirebaseMessaging && CustommerProfileTo.data().chatting_with !== email) {//
            // Get info user from (sent)
            admin
              .firestore()
              .collection('CustomerProfile')
              .where('email', '==', email)//
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(CustommerProfileFrom => {
                  console.log(`Found user from: ${CustommerProfileFrom.data().user_name}`)
                  const payload = {
                    notification: {
                      title: `Bạn nhận được tin nhắn từ: "${CustommerProfileFrom.data().user_name}"`,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default'
                    }
                  }

                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(CustommerProfileTo.data().tokenFirebaseMessaging, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          } else {
            console.log('Can not find tokenFirebaseMessaging target user')
          }
        })
      })
    return null
  })
  exports.sendNotificationSystemUsers = functions.firestore
    .document('NotifySystemUsers/{notify_system_users}')
    .onCreate((snap, context) => {
      console.log('----------------start function NotifySystemUsers--------------------')

      const doc = snap.data()
      console.log(doc)

      const title = doc.title//
      //const typeTo = doc.typeTo//
      const content = doc.content

      // Get push token user to (receive)
      admin
        .firestore()
        .collection('CustomerProfile')
        .where('type', '==', 1)//
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(CustommerProfileTo => {
            console.log(`Found user to: ${CustommerProfileTo.data().user_name}`)
            if (CustommerProfileTo.data().tokenFirebaseMessaging) {
              // Get info user from (sent)
              const payload = {
                notification: {
                  title: `Bạn nhận được thông báo ${title}`,
                  body: content,
                  badge: '1',
                  sound: 'default'
                  
                }
              }

              // Let push to the target device
              admin
                .messaging()
                .sendToDevice(CustommerProfileTo.data().tokenFirebaseMessaging, payload)
                .then(response => {
                  console.log('Successfully sent message:', response)
                })
                .catch(error => {
                  console.log('Error sending message:', error)
                })
              } else {
                console.log('Can not find tokenFirebaseMessaging target user')
              }
            })
          })
        return null
      })
      exports.sendNotificationProductAds = functions.firestore
          .document('NotifyProductAds/{notify_product_ads}')
          .onCreate((snap, context) => {
            console.log('----------------start function NotifyProductAds--------------------')

            const doc = snap.data()
            console.log(doc)

            const title = doc.title//
            //const typeTo = doc.typeTo//
            const content = doc.content

            // Get push token user to (receive)
            admin
              .firestore()
              .collection('CustomerProfile')
              .where('type', '==', 0)//
              .get()
              .then(querySnapshot => {
                querySnapshot.forEach(CustommerProfileTo => {
                  console.log(`Found user to: ${CustommerProfileTo.data().user_name}`)
                  if (CustommerProfileTo.data().tokenFirebaseMessaging) {
                    // Get info user from (sent)
                    const payload = {
                      notification: {
                        title: title,
                        body: content,
                        badge: '1',
                        sound: 'default'

                      }
                    }

                    // Let push to the target device
                    admin
                      .messaging()
                      .sendToDevice(CustommerProfileTo.data().tokenFirebaseMessaging, payload)
                      .then(response => {
                        console.log('Successfully sent message:', response)
                      })
                      .catch(error => {
                        console.log('Error sending message:', error)
                      })
                    } else {
                      console.log('Can not find tokenFirebaseMessaging target user')
                    }
                  })
                })
              return null
            })