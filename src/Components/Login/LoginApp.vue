<template>

    <article>
        <div class="container" :class="{'sign-up-active' : signUp}">
            <div class="overlay-container">
                <div class="overlay">
                    <div class="overlay-left">
                        <h2>Welcome Back!</h2>
                        <p>please login with ur info</p>
                        <button class="invert" id="signIn" @click="signUp = !signUp">Sign in</button>
                    </div>
                    <div class="overlay-right">
                        <h2>Hello, Friend!</h2>
                        <p>please enter ur personal details</p>
                        <button class='invert' id="signUp" @click="signUp = !signUp">Sign up</button>
                    </div>
                </div>
            </div>

            <form class="sign-up" action="#">
                <h2>Create Login</h2>
                <div>Use ur email for registration</div>
                <input type="text" placeholder="Name">
                <input type="email" placeholder="Email">
                <input type="password" placeholder="Password">
                <button>Sign up</button>
            </form>

            <form class="sign-in" action="#">
                <h2>Sign in</h2>
                <div>Use ur acount</div>
                <input type="email" placeholder="Email">
                <input type="password" placeholder="Password">
                <a href="#">Forgot ur Password?</a>
                <button>Sign in</button>
            </form>

        </div>
    </article>




</template>

<script>
export default {
        data() {
            return {
                signUp: false,
            }
        },
    }
</script>

<style  lang="scss" scoped >

.container{
    position: absolute;
    top: 20%;
    left: 20%;
   
    width: 768px;
    height: 450px;
   border-radius:10px;
   overflow: hidden;
   box-shadow: 0 15px 30px rgba(0,0,0,2),0 15px 30px rgba(0, 0, 0, 2);
   background: linear-gradient(to botton, white,#ccc);

.overlay-container {
        position: absolute;
        top: 0;
        left: 50%;
        width: 50%;
        height: 100%;
        overflow: hidden;
        transition: transform .5s ease-in-out;
        z-index: 100;
    }

    .overlay {
        position: relative;
        left: -100;
        height: 100%;
        width: 200%;
        background: linear-gradient(to bottom right, #7fd625,#009345 );
        color: white;
        transform: translateX(0%);
        transition: transform .5s ease-in-out;

    }

    @mixin overlays ($property){
        position: absolute;
            top: 0;
            display: flex;
            align-items: center;
            justify-content: space-evenly;
            flex-direction: column;
            padding: 70px 40px;
            width: calc(50% - 80px);
            height: calc(100% - 140px);
            text-align: center;
            transform: translateX($property);
            transition: transform .5s ease-in-out;
    }

    .overlay-left {
        @include overlays(-100%);
        
    }

    .overlay-right {
        @include overlays(0);
        
        
        
    }

    h2 {
        margin: 0;
    }

    p {
        margin: 20px 0 30px;
    }

    a{
        color: black;
        text-decoration:  none;
        margin: 15px 0;
        font-size: 1rem;
    }

    button {
        border-radius: 20px;
        border: 1px solid #009345;
        background-color: #009345;
        color: white;
        font-size: 1rem;
        font-weight: bold;
        padding: 10px 40px;
        letter-spacing: 1px;
        text-transform: uppercase;
        transition: transform .1s ease-in;

        &:active {
        transform: scale(.9);
    }

    &:focus {
        outline: none;
    }

    }

    

    
}

button.invert {
    background-color: transparent;
    border-color: white;
}

form{
    position: absolute;
    top: 0;
    display: flex;
    align-items: center;
    justify-content: space-evenly;
    flex-direction: column;
    padding: 80px 60px;
    width: calc(45% - 80px);
        height: calc(100% - 140px);
    text-align: center;
    background: linear-gradient(to bottom, white, gray);
    transition: all .5 ease-in-out;
}

div{
    font-size: 1rem;
}

input{
    background-color: white;
    border: none;
    padding: 8px 20px;
    margin: 3px 0;
    width: calc(100% - 30%);
    border-radius: 15px;
    border-bottom: 1px solid white;
    box-shadow: inset 0 1px 2px rgba(0,0,0,.4),
    0 -1px 1px white,
    0 1px 0 white;
    overflow: hidden;

    &:focus {
        outline: none;
        background-color: wheat;
    }
}
   .sign-in{
    left: 0;
    z-index: 2;
   }

.sign-up {
    left: 0;
    z-index: 1;
    opacity: 0;

}

.sign-up-active{
    .sign-in{
        transform: translateX(100%)
    }

    .sign-up {
        transform: translateX(100%);
        opacity: 1 ;
        z-index: 5;
    }

    .overlay-container {
        transform: translateX(-100%)
    }

    .overlay-left{
        transform: translateX(0);
    }

    .overlay-right{
        transform: translateX(100%);
    }

    

    
}




</style>