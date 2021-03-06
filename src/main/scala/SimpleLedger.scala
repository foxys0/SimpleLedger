import actors.TransactionActor
import actors.TransactionActor.{GracefulShutdown, Transaction}
import akka.actor.typed.ActorSystem
import cats.effect.{ExitCode, IO, IOApp}
import cats.implicits._
import com.typesafe.scalalogging.LazyLogging
import common.Configuration.buildConfig

object SimpleLedger extends IOApp with LazyLogging {

  def run(args: List[String]): IO[ExitCode] = args.headOption match {
    case Some(path) => runSuccess(path)
    case None => runError
  }

  def runError: IO[ExitCode] =
    IO(logger.error("You must specify configuration file"))
      .as(ExitCode.Error)

  def runSuccess(path: String): IO[ExitCode] =
    (
      for {
        _ <- IO(logger.info("Starting the application"))
        config <- IO(buildConfig(path))
        system = ActorSystem(TransactionActor(), "Transactions", config)
      } yield {
        system ! Transaction
        system ! Transaction
        system ! Transaction
        system ! Transaction

        Thread.sleep(10000)
        system ! GracefulShutdown
      }
    ).as(ExitCode.Success)

}
