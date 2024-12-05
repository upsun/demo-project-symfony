import './page.css';
import {SpeakerList, Podium} from "./component/podium";

const Home = () => {
  return (
      <div className={'container'}>
        <nav className="navbar navbar-expand">
          <a className={"navbar-brand"} href="/">
            <img src="https://s2.qwant.com/thumbr/280x122/e/e/b5d5772ba90bc19429884de88b7a9a16b899624173e1c3ff8c005afc13ee76/th.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%3Fid%3DOIP.HP2RBmw3Ftrd_EyEQg4b6wAAAA%26pid%3DApi&q=0&b=1&p=0&a=0" width="25" height="30"
                 className="d-inline-block align-top" alt="podium"/>
          </a>
          <div className={"navbar-title"}>SymfonyCon Vienna 2024</div>
          <a className={"navbar-brand"} href="/">
            <img src="https://raw.githubusercontent.com/upsun/.github/main/profile/logo.svg" width="25" height="30"
                 className="d-inline-block align-top" alt="podium"/>
          </a>
        </nav>

        <Podium/>
        <SpeakerList/>
      </div>
  );
}
export default Home;
