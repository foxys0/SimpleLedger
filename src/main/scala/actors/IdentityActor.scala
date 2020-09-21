package actors

import akka.actor.typed.scaladsl.Behaviors
import akka.actor.typed.{ActorRef, Behavior}
import common.Configuration
import common.Domain.{FullName, Id}

object IdentityActor {

  sealed trait Response
  case class IdentityRequest(senderId: Id, receiverId: Id, replyTo: ActorRef[Response])
  case class IdentityResponse(sender: FullName, receiver: FullName) extends Response
  case class FailedResponse(reason: String) extends Response

  def apply(): Behavior[IdentityRequest] =
    Behaviors.receive { (context, msg) =>
      context.log.info("IdentityRequest received")

      val db = Configuration(context.system).database
      (
        for {
          receiver <- db.getPersonFullName(msg.receiverId)
          sender <- db.getPersonFullName(msg.senderId)
        } yield IdentityResponse(FullName(receiver), FullName(sender))
      ).value.unsafeRunSync() match {
        case Some(identityResponse) => msg.replyTo ! identityResponse
        case None => msg.replyTo ! FailedResponse("Person not found")
      }

      Behaviors.same
    }

}
