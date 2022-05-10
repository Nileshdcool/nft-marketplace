import React, { Component } from 'react';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import KryptoBird from '../abis/KryptoBird.json';
import {
    Collapse,
    Navbar,
    NavbarToggler,
    NavbarBrand,
    Nav,
    NavItem,
    NavLink
} from 'reactstrap';
import {MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn} from 'mdb-react-ui-kit';
import './App.css';




class App extends Component {

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            kryptoBirdz: []
        }
    }

    async componentDidMount() {
        await this.loadWeb3()
        await this.loadBlockchainData();
    }

    // first up is t detyetc etherem provider

    async loadWeb3() {
        const provider = await detectEthereumProvider();
        if (provider) {
            console.log('ethereum wallet is connected');
            window.web3 = new Web3(provider);
        } else {
            console.log('ethereum wallet is not connected');
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3;
        await window.ethereum.enable()
        const accounts = await window.web3.eth.getAccounts();
        this.setState({ account: accounts[0] })
        const networkId = await web3.eth.net.getId();
        const networkData = KryptoBird.networks[networkId];
        if (networkData) {
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);

            this.setState({ contract })
            const totalSupply = await contract.methods.totalSupply().call();
            this.setState({ totalSupply })
            console.log(this.state.totalSupply);

            for (let i = 1; i <= totalSupply; i++) {
                // kryptoBirdz this is array variable which we are accessing elements
                const KryptoBird = await contract.methods.kryptoBirdz(i - 1).call()
                this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
                });
            }

            //lecture 227
            console.log(this.state.kryptoBirdz);
        } else {
            window.alert('Smart Contract not deployed');
        }
    }

    // with minting we are sending information and we need to specifiy the account
    mint = (kryptoBird) => {
        this.state.contract.methods.mint(kryptoBird).send({ from: this.state.account })
            .once('receipt', (receipt) => {
                this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
                });
            })
    }
    render() {
        return (
            <div>
                {console.log(this.state.kryptoBirdz)}
                <Navbar color="dark" expand="md">
                    <NavbarBrand color="primary" href="/">Krypto Bird Nfts (Non fungible tokens)</NavbarBrand>
                    <NavbarToggler onClick={this.toggle} />
                    <Collapse isOpen={this.state.isOpen} navbar>
                        <Nav className="ml-auto" navbar>
                            <NavItem>
                                <NavLink href="/components/">{this.state.account[0]}</NavLink>
                            </NavItem>
                        </Nav>
                    </Collapse>
                </Navbar>
                <div className='container-fluid mt-1'>
                    <div className='row'>
                        <main role='main' className='col-lg-12 d-flex text-center'>
                            <div className='content mr-auto ml-auto' style={{ opacity: '0.8' }}>
                                <h1 style={{ color: 'black' }}>
                                    KryptoBirdz - NFT Marketplace</h1>
                                <form onSubmit={(event) => {
                                    event.preventDefault();
                                    const kryptoBird = this.kryptoBird.value;
                                    this.mint(kryptoBird);
                                }}>
                                    <input style={{ margin: '6px' }} ref={(input) => this.kryptoBird = input} type='text' placeholder='Add a file location' className='form-control mb-1'></input>
                                    <input style={{ margin: '6px' }}
                                        type='submit'
                                        className='btn btn-primary btn-black'
                                        value='MINT'
                                    />

                                </form>
                            </div>
                        </main>
                    </div>
                    <hr></hr>
                        <div className='row textCenter'>
                            {this.state.kryptoBirdz.map((kryptoBird, key)=>{
                                return(
                                    <div >
                                        <div>
                                            <MDBCard className='token img' style={{maxWidth:'22rem'}}>
                                            <MDBCardImage src={kryptoBird}  position='top' height='250rem' style={{marginRight:'4px'}} />
                                            <MDBCardBody>
                                            <MDBCardTitle> KryptoBirdz </MDBCardTitle> 
                                            <MDBCardText> The KryptoBirdz are 20 uniquely generated KBirdz from the cyberpunk cloud galaxy Mystopia! There is only one of each bird and each bird can be owned by a single person on the Ethereum blockchain. </MDBCardText>
                                            <MDBBtn href={kryptoBird}>Download</MDBBtn>
                                            </MDBCardBody>
                                            </MDBCard>
                                             </div>
                                    </div>
                                )
                            })} 
                        </div>
                </div>
            </div>
        )
    }
}

export default App;