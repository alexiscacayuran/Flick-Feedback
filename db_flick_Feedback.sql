PGDMP     (    1                |            flick_feedback    15.4    15.4                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16467    flick_feedback    DATABASE     �   CREATE DATABASE flick_feedback WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE flick_feedback;
                postgres    false            �            1259    16469    movies    TABLE     �   CREATE TABLE public.movies (
    id integer NOT NULL,
    title text,
    year text,
    release_date date,
    genre text,
    actors text,
    plot text,
    poster text,
    imdb_rating real,
    rated text,
    runtime text
);
    DROP TABLE public.movies;
       public         heap    postgres    false            �            1259    16468    movies_id_seq    SEQUENCE     �   CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.movies_id_seq;
       public          postgres    false    215            	           0    0    movies_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;
          public          postgres    false    214            �            1259    16487    notes    TABLE     �   CREATE TABLE public.notes (
    id integer NOT NULL,
    flick_rating integer,
    date_watched date,
    recommended boolean,
    notes text,
    movie_id integer
);
    DROP TABLE public.notes;
       public         heap    postgres    false            �            1259    16486    notes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.notes_id_seq;
       public          postgres    false    217            
           0    0    notes_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;
          public          postgres    false    216            j           2604    16472 	   movies id    DEFAULT     f   ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);
 8   ALTER TABLE public.movies ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    215    215            k           2604    16490    notes id    DEFAULT     d   ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);
 7   ALTER TABLE public.notes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216    217                       0    16469    movies 
   TABLE DATA           y   COPY public.movies (id, title, year, release_date, genre, actors, plot, poster, imdb_rating, rated, runtime) FROM stdin;
    public          postgres    false    215   �                 0    16487    notes 
   TABLE DATA           ]   COPY public.notes (id, flick_rating, date_watched, recommended, notes, movie_id) FROM stdin;
    public          postgres    false    217   �                  0    0    movies_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.movies_id_seq', 26, true);
          public          postgres    false    214                       0    0    notes_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.notes_id_seq', 27, true);
          public          postgres    false    216            m           2606    16476    movies movies_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.movies DROP CONSTRAINT movies_pkey;
       public            postgres    false    215            o           2606    16494    notes notes_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.notes DROP CONSTRAINT notes_pkey;
       public            postgres    false    217            p           2606    16495    notes notes_movie_id_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id);
 C   ALTER TABLE ONLY public.notes DROP CONSTRAINT notes_movie_id_fkey;
       public          postgres    false    217    3181    215                �  x����r�8���S� 1&L�9�&�	�S[5%��ȒG���2��[�r��r�-�����-&�����e�~7h�v���o�D��Ъ������N��ޣ��u`�Bʺ�<�K���h�T!<�*ɽD�2^ �JɅ�#W��a��!G���*��zo]d��Z�� 5ȋ�)�?�XYX��
r~Љ����\K�h��	�� ����[[V_//�� x���U'��%U�au�.�K��[�ߦѮf��������z�M�*J��4��Q�O߾u~�t�_{��ٖ�wݹ���{]��P��7A)�"�(�T�p�k�v�o����9Z0�W	z�[C٩��9W0�B�S%W$b*�7�.w�T��؈xВ�����QC*6DY(�����}�C�7Tz��K�-�Ko.U)y�wA}@C:��ו剤͈c��62����e\�K֟.�e�l�}���S��q0�l�L��/�8���ݘ����>��ח�Ez�S���ީ�	���^x9��^D�{�&m$����1_�}>s�rQ�7H`�n3��n�A��0o,Ŗ��:m�1bɟ��);5D)�0�Zt�����kaaCP��湠��DF��H���jU94&Њ���{��v<%0F���>�!��T�O~�]2`"M%�����߈��Y�9��y;�z�e���rqb��E������ĲS|ł9���j9��i=��6~o���-٥��y�뛳c�x���8��А��?�"���9/�K:X�f�I`.S��Ys����ICDJnx)1	0Nm�U�m�c�O+)4��݁4��b�u:fU�I�u�T躘q{DT�i,�x�FEr���VrƢ(��4�7m%Y�j����`V��?��^�`�h�cw�����c'f��������#�u`�.A���~��4`��\\\���         s  x��V�NcG]㯨86��L$v�"!%��lB��o�~\�a��9ݶ[0�HX ��U�N�zLߟ\�Lϧ�����d~��ס�Ib^oN�@�E�,��!R�L�$E,��d2i��i�����yB7�f�Ʌ(?�����?'�w�黓���j|ޜ�Cgd�R�@����$��8�%����Q�&?R�os�J�Jbe�q�r��*7<5��Y����.�9��.$�Rئ�3���7o<��ba�^;n�?�|�m�����>� �F�%�3Iq/�A�����%v2�W�d9��Sg�4�1v5���I�����1�9�Yɒ��_��`����i����#+�t�H\B��.�F{���}?4i20��F ��R���MR5A��V'�Y-^KD����_fŮ$R���mZ[rϙ�I��`�OL5�^8��%.w9����l�^O! ��8�;�(:t*I��G�.hYF�/B�ĄGC}�z��^��l�1e��U��W�22�A-JȯP�k��'v[�jeQ,��ƕx�QP�����X1s��U*h7,p�[6~�H���6�U#�b
�jz�i��P1٠|@���3aMj�������?�Hȉ�Pw��\Q�tA�\A��;nK�A�I	}�����k����5r0���J���
�$�	��$Ԡ�^�hw�2����P_����"���<o��)G����9�|��zt(�Y�� �X�N�X3�I�>����,D��K�5d��*��a7����kJ5�[���f�qBJ{�n86��f��k����p�oޡ}�J�7h�Z���: ��Z~VU��bKz�!�c��Aۺ�Q�V���@����g�Sv�6*���Q	�0��.O��Ԙ~f����s��`z�<�/^���#�Jȡ�b4F9�)��T|�n�a[.\X���Ϙ���z^K���]<<Pg���㶟�`�e^J�˲�����$_/߇�<� �bѵa���:�WFK�����PE~n{C��'3VW'f���[�]qU���-� �><�̶m�fg�F�v�u������ϕD�v�-#�y�欺�vξ�;������jl��(�ޜ0�g t�hx����0Ķ���r9���� ��     